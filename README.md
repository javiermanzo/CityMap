# CityMap

## Paging and Search Criteria

CitiesListViewModel provides a mechanism for loading and displaying a large list of cities efficiently, as well as a fast search capability. The main goals are:

1. **Paged Loading of Cities by First Character:**  
   Cities are grouped by their first letter. Rather than loading all cities at once, we load only a subset at a time. As the user scrolls, we load additional chunks of cities corresponding to subsequent characters.

2. **Fast Prefix-Based Search:**  
   When the user types a search query, we use the first character of that query to determine which subset of cities to consider, thus avoiding scanning through all of them.


### Paging for Performance

1. **Initial Full List Processing:**  
   When the cities are initially loaded, they are processed into:
   - A dictionary keyed by the first letter of the city name.
   - A sorted list of these keys.

   This pre-processing ensures that subsequent operations (search and pagination) are efficient.

2. **Paged Loading by First Letter:**
   Instead of showing all cities at once, the model:
   - Starts by loading cities for the first character key until it reaches a certain threshold (20 cities).
   - If the user scrolls to the bottom, it loads the next batch of cities corresponding to the next character in the sorted keys.
   - This continues until all keys have been exhausted or the user stops scrolling.

By loading and displaying cities incrementally:
- **Memory usage is reduced** since not all 200k+ cities are displayed at once.
- **Initial load times improve**, as the user immediately sees some results without waiting for the entire dataset to appear.
- **Smooth scrolling experience** as additional cities are loaded only when needed.

### How the Search Works

1. **Dictionary by First Letter:**  
   We split the cities into groups using a dictionary where the **key is the first character of the city name** and the **value is an array of cities starting with that character**.

2. **Prefix-Based Query:**  
   When the user types in the search bar, we:
   - Extract the first character of the search text.
   - Retrieve the array corresponding to that character from the dictionary.
   - Filter the resulting subset of cities by checking if each city's name **starts with the entire search text**.

This approach greatly improves performance during searches because we no longer scan every city. Instead, we perform a focused search on a much smaller subset.

