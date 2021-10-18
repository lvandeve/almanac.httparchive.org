#standardSQL
# Top A/B Testing used in Ecommerce sites
SELECT
  _TABLE_SUFFIX AS client,
  app,
  COUNT(DISTINCT url) AS freq,
  total,
  COUNT(DISTINCT url) / total AS pct
FROM
  `httparchive.technologies.2021_07_01_*`
JOIN (
  SELECT
    _TABLE_SUFFIX,
    url
  FROM
    `httparchive.technologies.2021_07_01_*`
  WHERE
    category = 'Ecommerce' AND
    (app != 'Cart Functionality' AND
     app != 'Google Analytics Enhanced eCommerce')
)
USING
  (_TABLE_SUFFIX, url)
JOIN (
  SELECT
    _TABLE_SUFFIX,
    COUNT(DISTINCT url) AS total
  FROM
    `httparchive.technologies.2021_07_01_*`
  WHERE
    category = 'Ecommerce' AND
    (app != 'Cart Functionality' AND
     app != 'Google Analytics Enhanced eCommerce')
  GROUP BY
    _TABLE_SUFFIX
)
USING
  (_TABLE_SUFFIX)
WHERE
  category = 'A/B Testing'
GROUP BY
  client,
  app,
  total
ORDER BY
  client DESC,
  pct DESC
