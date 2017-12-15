import subprocess
import networkx as nx
import matplotlib.pyplot as plt

def get_object_type(obj_id):
    process = subprocess.Popen('git cat-file -t {}'.format(obj_id),
                   shell=True, stdout=subprocess.PIPE)
    out, err = process.communicate()
    return out.decode('utf8').strip()

def get_commit_ids():
    process = subprocess.Popen('git rev-list --all', 
                   shell=True, stdout=subprocess.PIPE)
    out, err = process.communicate()
    return out.decode('utf8').split('\n')


def get_object_relations(obj_id, obj_type=None):
    def handle_commit(out):
        relations = [] 
        for line in out.split('\n'):
            fields = line.split()
            if len(fields) > 2: break
            relations.append(fields)
        return relations
    def handle_tree(out):
        relations = [] 
        for line in out.split('\n'):
            fields = line.split()
            if len(fields) > 2: break
            relations.append(fields)
        return relations
    def handle_parent(out):
        return [] 
    def handle_blob(out):
        return []
    
    HANDLERS = {
        'blob': handle_blob,
        'commit': handle_commit,
        'tree': handle_tree,
        'parent': handle_parent
    }
    if not obj_type:
        obj_type = get_object_type(obj_id)
    process = subprocess.Popen('git cat-file -p {}'.format(obj_id),
                   shell=True, stdout=subprocess.PIPE)
    out, err = process.communicate()
    out = out.decode('utf8')
    return HANDLERS[obj_type](out)   

def recurse_graph_find(graph, object_id):
    relations = get_object_relations(object_id)
    for rel in relations:
        if rel[1] not in recurse_graph_find.done:
            recurse_graph_find.done.add(rel[1])
            graph.add_node(rel[1])
            graph.add_edge(object_id, rel[1])
            recurse_graph_find(graph, rel[1])
recurse_graph_find.done = set()

 
def main():
    commits = get_commit_ids()[:-1]
    graph = nx.DiGraph()
    for commit in commits:
        graph.add_node(commit)
        recurse_graph_find(graph, commit)

    nx.draw(graph)
    plt.draw()
    plt.show()

if __name__ == '__main__':
    main()
