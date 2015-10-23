		</div>
		<div id="push"></div>
    </div>

    <div id="footer">
      <div class="container">
        <p class="muted credit">&copy; 2015 | Mixed with <a href="http://getbootstrap.com/">Bootstrap v3.1.1</a> | Baked with <a href="http://jbake.org">JBake ${version}</a> | Licensed under the <a href="http://www.wtfpl.net/"/>WTFPL 2.0</a></p>
      </div>
    </div>

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="<#if (content.rootpath)??>${content.rootpath}<#else></#if>js/jquery-1.11.1.min.js"></script>
    <script src="<#if (content.rootpath)??>${content.rootpath}<#else></#if>js/bootstrap.min.js"></script>
    <script src="<#if (content.rootpath)??>${content.rootpath}<#else></#if>js/prettify.js"></script>
    <script src="<#if (content.rootpath)??>${content.rootpath}<#else></#if>js/galleria/galleria-1.4.2.min.js"></script>
    <style>
      .galleria{ width: 700px; height: 400px; background: #000 }
    </style>
    <script>
        Galleria.loadTheme('<#if (content.rootpath)??>${content.rootpath}<#else></#if>js/galleria/themes/classic/galleria.classic.min.js');
        Galleria.run('.galleria');   // Use the class name of your gallery
     </script>
  </body>
</html>
