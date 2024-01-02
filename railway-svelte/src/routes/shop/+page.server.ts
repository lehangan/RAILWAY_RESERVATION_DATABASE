export async function load({ locals }) {
	// Querying: https://node-postgres.com/features/pooling
	const res_satan = await locals.client.query('SELECT * FROM station');

	return { 
		stations: res_satan.rows.map(row => { 
			return {
				value: row.station_id,
				label: row.station_name + ", " + row.city
			}
		}),
	};
}