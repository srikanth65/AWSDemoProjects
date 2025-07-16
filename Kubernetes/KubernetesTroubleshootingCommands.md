Kubernetes Troubleshooting Commands

kubectl get pods --all-namespaces: Check pod statuses across all namespaces.

kubectl describe pod <pod_name>: Gather detailed information about a specific pod.

kubectl logs <pod_name> -c <container_name>: View logs of a specific container.

kubectl get events --sort-by='.metadata.creationTimestamp': Review recent events for errors.

kubectl get nodes: Verify the health and status of cluster nodes.

kubectl drain <node_name> --ignore-daemonsets: Safely evacuate pods from a node.

kubectl cordon <node_name>: Mark a node as unschedulable.

kubectl uncordon <node_name>: Mark a node as schedulable again.

kubectl delete pod <pod_name> --grace-period=0 --force: Forcefully delete a crashed pod.

kubectl rollout undo deployment <deployment_name>: Roll back a problematic deployment.

kubectl exec -it <pod_name> -- /bin/sh: Access a container for debugging.

kubectl get componentstatuses: Check the health of core cluster components.

kubectl top nodes: Monitor node resource usage for bottlenecks.

kubectl top pods --all-namespaces: Identify resource-hungry pods.

kubectl delete node <node_name>: Remove a failed node from the cluster.

kubectl get ingress: Verify ingress resources and their statuses.

kubectl describe <resource_type> <resource_name>: Detailed information for a resource.

kubectl port-forward <pod_name> <local_port>:<remote_port>: Forward a local port to a pod.

kubectl get endpoints <service_name>: Verify service endpoints.

kubectl apply -f <backup.yaml>: Restore configurations from a backup manifest.

kubectl taint nodes <node_name> key=value:NoSchedule: Prevent scheduling on a problematic node.

kubectl debug <pod_name>: Launch an ephemeral container for troubleshooting.

kubectl edit <resource_type> <resource_name>: Manually modify resource configurations.

kubectl proxy: Start a proxy to the Kubernetes API for debugging.
