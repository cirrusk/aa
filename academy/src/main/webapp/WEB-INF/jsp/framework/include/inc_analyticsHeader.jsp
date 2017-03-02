
<c:choose>
    <c:when test="${analBox.urlaccess eq 'OPER' }">
        <!-- analytics AI production (TBD) -->
        <script src="//assets.adobedtm.com/82aecb95e0b4e7a4cd5816c4c5d4fb1902bdbcf5/satelliteLib-a1be4b37db6eea7c35859ed88c870d1b39caf70d.js"></script>
    </c:when>
    <c:otherwise>
        <!-- analytics AI staging (TBD) -->
        <script src="//assets.adobedtm.com/82aecb95e0b4e7a4cd5816c4c5d4fb1902bdbcf5/satelliteLib-a1be4b37db6eea7c35859ed88c870d1b39caf70d-staging.js"></script>
    </c:otherwise>
</c:choose>

