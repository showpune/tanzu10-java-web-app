update_settings ( max_parallel_updates = 3 , k8s_upsert_timeout_secs = 120 , suppress_unused_image_warnings = None ) 
allow_k8s_contexts('debug-performance-test-admin')
SOURCE_IMAGE = os.getenv("SOURCE_IMAGE", default='tanzucontainer.azurecr.io/tanzu10-source')
LOCAL_PATH = os.getenv("LOCAL_PATH", default='.')
NAMESPACE = os.getenv("NAMESPACE", default='business-development')

k8s_custom_deploy(
    'tanzu10-java-web-app',
    apply_cmd="tanzu apps workload apply -f config/workload.yaml --live-update" +
               " --local-path " + LOCAL_PATH +
               " --source-image " + SOURCE_IMAGE +
               " --namespace " + NAMESPACE +
               " --yes " +
               " && kubectl get workload tanzu10-java-web-app --namespace " + NAMESPACE + " -o yaml",
    delete_cmd="tanzu apps workload delete -f config/workload.yaml --namespace " + NAMESPACE + " --yes",
    deps=['pom.xml', './target/classes'],
    container_selector='workload',
    live_update=[
      sync('./target/classes', '/workspace/BOOT-INF/classes')
    ]
)

k8s_resource('tanzu10-java-web-app', port_forwards=["8080:8080"],
            extra_pod_selectors=[{'serving.knative.dev/service': 'tanzu10-java-web-app'}])
