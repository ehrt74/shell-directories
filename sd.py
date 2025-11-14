#!/usr/bin/env python3

import json
import sys
import os
import itertools

def try_except(l, fallback):
    try:
        return l()
    except:
        return fallback

def calculate_index (paths, index):
    first_empty_index = try_except(lambda: paths.index(None), None)
    if first_empty_index != None:
        return first_empty_index
    elif len(paths) < 10:
        return -1
    else:
        return (index + 1) % 10

def trim_empty_right (paths):
    paths.reverse()
    new_paths = list(itertools.dropwhile(lambda x: x==None, paths))
    new_paths.reverse()
    return new_paths

def save_db(db_path, db):
    paths = db.get('Paths', [])
    index = db.get('CurrentIndex', -1)
    new_paths = trim_empty_right(paths)
    new_index = calculate_index(new_paths, index)
    with open(db_path, 'w') as f:
        json.dump({'Paths':new_paths, 'CurrentIndex': new_index}, f)
    
def get_db(path):
    try:
        with open(path) as f:
            return json.load(f)
    except:
        return {'CurrentIndex': -1, 'Paths': []}
    
    
def add_path(paths, index, new_path):
    if index != -1:
        paths[index] = new_path
    else:
        paths.append(new_path)
    return paths
    
def do_stuff(args):
    db = get_db(args[0])
    paths = db.get('Paths', [])
    index = db.get('CurrentIndex', -1)
    match args[1]:
        case "get":
            return paths[int(args[2])]
        case "list":
            return "\n".join([ "{} {} {}".format(i, "*" if i==index else " ", x) for i, x in enumerate(paths)])
        case "add":
            db['Paths']=add_path(paths, index, os.getcwd())
            save_db(args[0], db)
            return None
        case "clear":
            save_db(args[0], {})
            return None
        case "delete":
            i = int(args[2])
            if i < len(paths):
                db['Paths'][i] = None
                save_db(args[0], db)
            return None
    
if __name__ == '__main__':
    if len(sys.argv) > 2:
        res = do_stuff(sys.argv[1:])
        if res != None:
            print(res)
    else:
        print("")
                
            
