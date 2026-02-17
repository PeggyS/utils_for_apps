function dbparams = get_db_login_params(dbname)
% change these values as needed for where the database is running

[~, name] = system('hostname');
if strncmp(name, 'megameg', 7)
    dbparams.serveraddr = 'localhost';
elseif contains(lower(name), 'cle-')
    dbparams.serveraddr = '10.83.111.4';
elseif contains(lower(name), 'mmmmeggie')
	dbparams.serveraddr = '192.168.9.10';
else
	% not on a computer on the local network
	dbparams = [];
end

switch dbname
	case 'tdcs_vgait'
		dbparams.dbname = 'tdcs_vgait';
		dbparams.user = 'tdcs_vgait';
		dbparams.password = 'tdcs_vgait';
	case 'myopro_merit'
		dbparams.dbname = 'myopro_merit';
		dbparams.user = 'myomo';
		dbparams.password = 'user_myomo';
	case 'myomo'
		dbparams.dbname = 'myomo';
		dbparams.user = 'myomo';
		dbparams.password = 'user_myomo';
	case 'clinical_measures'
		dbparams.dbname = 'clinical_measures';
		dbparams.user = 'clinmeas';
		dbparams.password = 'dalyclinmeas';
	otherwise
		error('unknown database: %s', dbname)
end



