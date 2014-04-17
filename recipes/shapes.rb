#
# Cookbook Name:: metroextractor
# Recipe:: shapes
#

%w(
  processed_p
  processed_i
  coastline_p
  coastline_i
  post_errors
  post_missing
).each do |dir|
  bash "ogr2ogr merc #{dir}" do
    cwd   node[:metroextractor][:basedir]
    user  node[:metroextractor][:user]
    code  <<-EOH
      ogr2ogr -a_srs \
      "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs +over" \
      ex/merc/#{dir}.shp ex/coast/#{dir}.shp
    EOH
  end

  bash "tar merc #{dir}" do
    cwd   node[:metroextractor][:basedir]
    user  node[:metroextractor][:user]
    code  <<-EOH
      tar -C ex/merc -cvf - #{dir}.dbf #{dir}.prj #{dir}.shp #{dir}.shx | bzip2 > ex/#{dir}-merc.tar.bz2
    EOH
  end

  bash "ogr2ogr wgs84 #{dir}" do
    cwd   node[:metroextractor][:basedir]
    user  node[:metroextractor][:user]
    code  <<-EOH
      ogr2ogr -t_srs EPSG:4326 ex/wgs84/#{dir}.shp ex/merc/#{dir}.shp
    EOH
  end

  bash "tar wgs84 #{dir}" do
    cwd   node[:metroextractor][:basedir]
    user  node[:metroextractor][:user]
    code  <<-EOH
      tar -C ex/wgs84 -cvf - #{dir}.dbf #{dir}.prj #{dir}.shp #{dir}.shx | bzip2 > ex/#{dir}-latlon.tar.bz2
    EOH
  end
end
