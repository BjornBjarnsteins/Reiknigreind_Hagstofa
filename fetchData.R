require(pxweb)
income <- data.frame(get_pxweb_data(url='http://px.hagstofa.is/pxen/api/v1/en/Samfelag/launogtekjur/3_tekjur/VIN07001.px',
                                        dims=list('Region'='*', 'Economic activity'='*', 'Sex'='*', 'Year'='*'), clean=FALSE))