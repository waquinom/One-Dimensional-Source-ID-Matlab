function association = getNodesAssociatedWithIP(xIP, forceMesh)

coordinates = forceMesh.getConnectivityWithCoor();
n = length(xIP);
association=zeros(n,1);
for i=1:n
    association(i,:) = find(xIP(i)>=coordinates(:,1) & xIP(i)<coordinates(:,2)); 
end