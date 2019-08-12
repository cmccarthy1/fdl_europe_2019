gen_schema:([]recv_time:`timespan$();tweet:());

affected_individuals    :gen_schema
caution_advice          :gen_schema
donations_volunteering  :gen_schema
infrastructure_utilities:gen_schema
other_useful_info       :gen_schema
sympathy_prayers        :gen_schema
useless_info		:gen_schema

.u.upd:{insert[x;y]}
