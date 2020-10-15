conda activate ox


import requests
import folium
import polyline

url = "http://127.0.0.1:5000/route/v1/driving/13.388860,52.517037;13.385983,52.496891"
r = requests.get(url)
res = r.json()
res


def get_route(pickup_lon, pickup_lat, dropoff_lon, dropoff_lat):
    
    loc = "{},{};{},{}".format(pickup_lon, pickup_lat, dropoff_lon, dropoff_lat)
    url = "http://10.22.168.65:9080/route/v1/driving/"
    r = requests.get(url + loc) 
    if r.status_code!= 200:
        return {}
  
    res = r.json()   
    routes = polyline.decode(res['routes'][0]['geometry'])
    start_point = [res['waypoints'][0]['location'][1], res['waypoints'][0]['location'][0]]
    end_point = [res['waypoints'][1]['location'][1], res['waypoints'][1]['location'][0]]
    distance = res['routes'][0]['distance']
    
    out = {'route':routes,
           'start_point':start_point,
           'end_point':end_point,
           'distance':distance
          }

    return out


pickup_lon, pickup_lat, dropoff_lon, dropoff_lat = -117.851364,33.698206,-117.838925,33.672260
test_route = get_route(pickup_lon, pickup_lat, dropoff_lon, dropoff_lat)
test_route