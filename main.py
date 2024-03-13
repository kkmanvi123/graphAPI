from hw3_api import GraphAPI


def main():
    # Initialize the GraphAPI
    api = GraphAPI()

    # Build the person/book network
    api.add_node('Emily', 'Person')
    api.add_node('Spencer', 'Person')
    api.add_node('Brendan', 'Person')
    api.add_node('Trevor', 'Person')
    api.add_node('Paxton', 'Person')
    api.add_node('Cosmos', 'Book')
    api.add_node('Database Design', 'Book')
    api.add_node('The Life of Cronkite', 'Book')
    api.add_node('DNA and you', 'Book')

    api.add_edge('Emily', 'Database Design', 'bought')
    api.add_edge('Spencer', 'Cosmos', 'bought')
    api.add_edge('Spencer', 'Database Design', 'bought')
    api.add_edge('Brendan', 'Database Design', 'bought')
    api.add_edge('Brendan', 'DNA and you', 'bought')
    api.add_edge('Trevor', 'Cosmos', 'bought')
    api.add_edge('Trevor', 'Database Design', 'bought')
    api.add_edge('Paxton', 'Database Design', 'bought')
    api.add_edge('Paxton', 'The Life of Cronkite', 'bought')
    api.add_edge('Emily', 'Spencer', 'knows')
    api.add_edge('Spencer', 'Emily', 'knows')
    api.add_edge('Spencer', 'Brendan', 'knows')

    # Test the original get_adjacent method
    adjacent_nodes = api.get_adjacent('Spencer')
    expected_result = ['Cosmos', 'Database Design', 'Emily', 'Brendan']
    print(adjacent_nodes, expected_result)
    assert sorted(adjacent_nodes) == sorted(expected_result)

    # Test get_adjacent method with node_type filter
    adjacent_nodes = api.get_adjacent('Spencer', node_type='Person')
    expected_result = ['Emily', 'Brendan']
    assert sorted(adjacent_nodes) == sorted(expected_result)
    print(adjacent_nodes, expected_result)

    # Test get_adjacent method with edge_type filter
    adjacent_nodes = api.get_adjacent('Spencer', edge_type='bought')
    expected_result = ['Cosmos', 'Database Design']
    assert sorted(adjacent_nodes) == sorted(expected_result)
    print(adjacent_nodes, expected_result)

    # Test get_recommendations method for Spencer
    recommendations = api.get_recommendations('Spencer')
    expected_result = ['DNA and you']
    print(recommendations, expected_result)
    assert sorted(recommendations) == sorted(expected_result)

    print("All tests passed successfully!")


if __name__ == "__main__":
    main()
