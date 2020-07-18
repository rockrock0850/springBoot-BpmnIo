<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="java.util.Date"%>

<c:set var='now' value='<%=new Date()%>' />
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Hello World</title>

<!-- required modeler styles -->
<link rel="stylesheet"
	href="${contextPath}/static/thirdParty/bpmn/1.3.2/css/bpmn.css?v=${now}">
<link rel="stylesheet"
	href="${contextPath}/static/thirdParty/bpmn/1.3.2/css/diagram-js.css?v=${now}">

<!-- modeler distro -->
<script
	src="${contextPath}/static/thirdParty/bpmn/1.3.2/bpmn-modeler.development.js?v=${now}"></script>

<!-- needed for this example only -->
<script
	src="${contextPath}/static/thirdParty/jquery/3.3.1/jquery.js?v=${now}"></script>

<!-- example styles -->
<style>
html, body, #canvas {
	height: 100%;
	padding: 0;
	margin: 0;
}

.diagram-note {
	background-color: rgba(66, 180, 21, 0.7);
	color: White;
	border-radius: 5px;
	font-family: Arial;
	font-size: 12px;
	padding: 5px;
	min-height: 16px;
	width: 50px;
	text-align: center;
}

.needs-discussion:not (.djs-connection ) .djs-visual>:nth-child(1) {
	stroke: rgba(66, 180, 21, 0.7) !important; /* color elements as red */
}

#save-button {
	position: fixed;
	bottom: 20px;
	left: 20px;
}
</style>
</head>
<body>
	<div id="canvas"></div>

	<button id="save-button">print to console</button>

	<script>
		var diagramUrl = 'https://cdn.rawgit.com/bpmn-io/bpmn-js-examples/dfceecba/starter/diagram.bpmn';

		// modeler instance
		var bpmnModeler = new BpmnJS({
			container : '#canvas',
			keyboard : {
				bindTo : window
			}
		});

		/**
		 * Save diagram contents and print them to the console.
		 */
		function exportDiagram() {

			bpmnModeler.saveXML({
				format : true
			}, function(err, xml) {

				if (err) {
					return console.error('could not save BPMN 2.0 diagram', err);
				}

				alert('Diagram exported. Check the developer tools!');

				console.log('DIAGRAM', xml);
			});
		}

		/**
		 * Open diagram in our modeler instance.
		 *
		 * @param {String} bpmnXML diagram to display
		 */
		function openDiagram(bpmnXML) {

			// import diagram
			bpmnModeler.importXML(bpmnXML, function(err) {

				if (err) {
					return console.error('could not import BPMN 2.0 diagram', err);
				}

				// access modeler components
				var canvas = bpmnModeler.get('canvas');
				var overlays = bpmnModeler.get('overlays');

				// zoom to fit full viewport
				canvas.zoom('fit-viewport');

				// attach an overlay to a node
				overlays.add('SCAN_OK', 'note', {
					position : {
						bottom : 0,
						right : 0
					},
					html : '<div class="diagram-note">Mixed up the labels?</div>'
				});

				// add marker
				canvas.addMarker('SCAN_OK', 'needs-discussion');
			});
		}

		// load external diagram file via AJAX and open it
		$.get(diagramUrl, openDiagram, 'text');

		// wire save button
		$('#save-button').click(exportDiagram);
	</script>
</body>
</html>