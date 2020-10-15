import os
import requests
import json
import time
import csv
import pandas as pd
import argparse
from multiprocessing import *
from subprocess import Popen, PIPE

parser = argparse.ArgumentParser(description='Description of your program')
parser.add_argument('-d', '--Directory', help='Log directory', required=False)
parser.add_argument('-m', '--Map', help='Map file', required=False)
args = vars(parser.parse_args())

class OsrmEngine(object):
    """ Class which connects to an osrm-routed executable and spawns multiple servers"""
    def __init__(self,
                 map_loc,
                 router_loc):
        """
        Map needs to be pre-processed with osrm-prepare; router_loc should be the most up to date file from here:
        http://build.project-osrm.org/ - both can work over the network with no significant speed-fall as they
        are initially loaded into RAM
        """
        if not os.path.isfile(router_loc):
            raise Exception("Could not find osrm-routed executable at: %s" % router_loc)
        else:
            self.router_loc = router_loc
        if not os.path.isfile(map_loc):
            raise Exception("Could not find osrm network data at: %s" % map_loc)
        else:
            self.map_loc = map_loc
        self.OsrmKill()

    def OsrmKill(self):
        """
        Kill any osrm-routed server that is currently running before spawning new - this means only one script
        can be run at a time
        """
        Popen('taskkill /f /im %s' % os.path.basename(self.router_loc), stdin=PIPE, stdout=PIPE, stderr=PIPE)

    def OsrmServer(self,
                   osrmport=5005,
                   osrmip='127.0.0.1'):
        """c
        Robustness checks to make sure server can be initialised
        """
        try:
            p = Popen([self.router_loc, '-v'], stdin=PIPE, stdout=PIPE, stderr=PIPE)
            output = p.communicate()[0].decode("utf-8")
        except FileNotFoundError:
            output = ""
        if "info" not in str(output):
            raise Exception("OSM does not seem to work properly")
        try:
            if requests.get("http://%s:%d" % (osrmip, osrmport)).status_code == 400:
                raise Exception("osrm-routed already running - force close all with task-manager")
        except requests.ConnectionError:
            pass
        Popen("%s %s -i %s -p %d" % (self.router_loc, self.map_loc, osrmip, osrmport), stdout=PIPE)
        try_c = 0
        while try_c < 30:
            try:
                if requests.get("http://%s:%d" % (osrmip, osrmport)).status_code == 400:
                    return "http://%s:%d" % (osrmip, osrmport)
                else:
                    raise Exception("Map could not be loaded")
            except requests.ConnectionError:
                    time.sleep(10)
                    try_c += 1
        raise Exception("Map could not be loaded ... taking more than 5 minutes..")

    def SpawnOsrmServer(self):
        """ Server can handle parallel requests so only one instance needed """
        thrds=1
        pool = Pool(thrds)
        servs = pool.map(self.OsrmServer, [i for i in range(5005, 5005+thrds)])
        pool.close()
        pool.join()
        return servs


def ReqOsrm(url_input):
    """
    Submits HTTP request to server and returns distance metrics; errors are coded as status=999
    """
    req_url, query_id = url_input
    try_c = 0
    #print(req_url)
    while try_c < 5:
        try:
            response = requests.get(req_url)
            json_geocode = response.json()
            status = int(json_geocode['status'])
            # Found route between points
            if status == 200:
                tot_time_s = json_geocode['route_summary']['total_time']
                tot_dist_m = json_geocode['route_summary']['total_distance']
                used_from = json_geocode['via_points'][0]
                used_to = json_geocode['via_points'][1]
                out = [query_id,
                       status,
                       tot_time_s,
                       tot_dist_m,
                       used_from[0],
                       used_from[1],
                       used_to[0],
                       used_to[1]]
                return out
            # Cannot find route between points (code errors as 999)
            else:
                print("Done but no route: %d %s" % (query_id, req_url))
                return [query_id, 999, 0, 0, 0, 0, 0, 0]
        except Exception as err:
            print("%s - retrying..." % err)
            time.sleep(5)
            try_c += 1
    print("Failed: %d %s" % (query_id, req_url))
    return [query_id, 999, 0, 0, 0, 0, 0, 0]


def CreateUrls(route_csv, osrmserver):
    """ Python list comprehension to create URLS """
    return [["{0}/viaroute?loc={1},{2}&loc={3},{4}&alt=false&geometry=false".format(
        osrmserver[0], alat, alon, blat, blon),
                qid] for qid, alat, alon, blat, blon in route_csv]


def LoadRouteCSV(csv_loc):
    """ Use Pandas to iterate through CSV - very fast CSV parser """
    if not os.path.isfile(csv_loc):
        raise Exception("Could not find CSV with addresses at: %s" % csv_loc)
    else:
        return pd.read_csv(csv_loc,
                           sep=',',
                           header=None,
                           iterator=True,
                           chunksize=1000000)

if __name__ == '__main__':
    try:
        # Router_loc points to latest build http://build.project-osrm.org/
        router_loc = '.../osrm_latest/osrm-routed.exe'
        # Directory containing routes to process (csv) and map supplied as arg.
        directory_loc = os.path.normpath(args['Directory'])
        map_loc = os.path.normpath(args['Map'])

        print("Initialising engine")
        osrm = OsrmEngine(map_loc, router_loc)
        print("Loading Map - this may take a while over the network")
        osrmserver = osrm.SpawnOsrmServer()
        done_count = 0
        # Loop through 1 million rows at a time (save results)
        with open(os.path.join(directory_loc, 'osrm_output.csv'), 'w') as outfile:
            wr = csv.writer(outfile, delimiter=',', lineterminator='\n')
            for x in LoadRouteCSV(csv_loc=os.path.join(directory_loc, 'osrm_input.csv')):
                # Pandas dataframe to python list
                routes = x.values.tolist()
                # Salt route-data with server location to create URLS
                url_routes = CreateUrls(routes, osrmserver)
                del routes
                print("Created %d urls" % len(url_routes))
                print("Calculating in chunks of 1,000,000")
                # Save one thread for server (running full may bring errors ...
                # such as requests not being filled
                pool = Pool(int(cpu_count()-1))
                calc_routes = pool.map(ReqOsrm, url_routes)
                del url_routes
                # Verify all threads closed safely
                pool.close()
                pool.join()
                wr.writerows(calc_routes)
                done_count += len(calc_routes)
                # Continually update progress in terms of millions
                print("Saved %d calculations" % done_count)
        print("Done.")
        osrm.OsrmKill()
    except Exception as err:
        osrm.OsrmKill()
        print(err)
        time.sleep(15)