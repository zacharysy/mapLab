function [path, distanceHist] = nns(Graph, start, destination, toAvoid)

%   Initialize start, end, and current nodes
    startNode = findnode(Graph, {start});
    destNode = findnode(Graph, {destination});
    currentNode = startNode;

%   Initialize path and distances arrays
    distanceHist = zeros(1, length(numnodes(Graph)));
    
    path = [currentNode];
    visited = [currentNode];
    nextNode = 0;
    
    while currentNode ~= destNode
        adjacents = neighbors(Graph, currentNode);
        weights = zeros(1, length(neighbors(Graph, currentNode)));
        
        for i=1:length(adjacents)
            neighbor = adjacents(i);
            if (~(sum(ismember(visited, neighbor))) && neighbor ~= toAvoid)
                weights(i) = Graph.Edges.Weight(findedge(Graph, currentNode, neighbor));  
            else
                weights(i) = inf;
            end
        end
        
        leastEdgeIndex = find(weights == min(weights));
        nextNode = findnode(Graph, adjacents(leastEdgeIndex));
        distanceHist = [distanceHist, weights(leastEdgeIndex)];
        
        
        
        currentNode = nextNode;
        path = [path, currentNode];
        visited = [visited, currentNode];
        nextNode = 0;

    end       
end
    



%{


    for i=1:length(adjacents)
        if Graph.Edges.Weight(findedge(Graph, currentNode, adjacents(i))) == leastEdge
            nextNode = findnode(Graph, i);
        end
    end        
    currentNode = nextNode;

function [path, finalDest] = nns(nodes, destination)
    startNode = nodes(1);
    distances = zeros(1, length(nodes));
    visited = strings(1, length(nodes));
    
%% Initial Values
    currentNode = startNode;
    visited(1) = currentNode.Name;
    distances(1) = 0;
     
%% Search: Get adjacents -> find min(adjacents) -> update state & current node
    while ~strcmp(currentNode.Name,destination.Name)
        count = 2;  % <count> starts at 2 since entry 1 is the current node
        adjDist = currentNode.AdjacentDistances;
        
        for i=1:length(adjDist)
            j = least(adjDist, 1);
            visited = [visited, currentNode];
            distances(count) = adjDist(j);
            [~, k] = nodeInArray(nodes, currentNode.AdjacentNodes(j));
            currentNode = nodes(k);
        end
        count = count + 1;
    end
    
 %% Done
    path = visited;
    finalDest = distances;
end



% Gets index of node with least distance
function i = least(nodeDist,ignore)
    sorted = sort(nodeDist);
    i = find(nodeDist==sorted(1+ignore),1);
end

% Finds if node with name 'node' is in an array
function [bool,index] = nodeInArray(arr,node)
    bool = 0;
    index = 0;

    for i = 1:length(arr)
        if strcmp(arr(i).Name,node)
            bool = 1;
            index = i;
        end
    end
end
%}
