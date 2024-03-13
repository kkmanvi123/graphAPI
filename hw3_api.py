import redis


class GraphAPI:

    def __init__(self):
        """ Initialize API """
        self.redis_client = redis.Redis('localhost', 6379, decode_responses=True)
        self.redis_client.flushall()

    def add_node(self, name, type):
        """ Add a node to the database of a given name and type """
        node_key = f'node:{name}'
        node_info = {
            'name': name,
            'type': type
        }
        self.redis_client.hmset(node_key, node_info)

    def add_edge(self, name1, name2, type):
        """
        Add an edge between nodes named name1 and name2.
        Type is the type of the edge or relationship.
        """
        edge_key = f'edge:{name1}:{name2}'
        edge_info = {
            'name1': name1,
            'name2': name2,
            'type': type
        }
        self.redis_client.hmset(edge_key, edge_info)

    def get_adjacent(self, name, node_type=None, edge_type=None):
        """
        Get the names of all adjacent nodes. User may optionally specify that the adjacent
        nodes are of a given type and/or only consider edges of a given type.
        """
        adjacent_nodes = []
        for key in self.redis_client.scan_iter(match=f'edge:{name}:*'):
            node_name = key.split(':')[2]
            edge_info = self.redis_client.hgetall(key)
            if edge_type and edge_info.get('type') != edge_type:
                continue
            if node_type:
                node_info = self.redis_client.hgetall(f'node:{node_name}')
                if node_info.get('type') == node_type:
                    adjacent_nodes.append(node_name)
            else:
                adjacent_nodes.append(node_name)
        return adjacent_nodes

    def get_recommendations(self, name):
        """
        Gets recommendations based on specific node/name.
        """
        # Get friends
        friends = self.get_adjacent(name)

        # Store recommendations
        recommendations = []

        # Iterate through each friend
        for friend in friends:
            # Get the books bought by the friend
            books = self.get_adjacent(friend, edge_type='bought')

            # Check each book if it's not already bought by the person
            for book in books:
                if book not in self.get_adjacent(name, edge_type='bought'):
                    recommendations.append(book)

        return recommendations
