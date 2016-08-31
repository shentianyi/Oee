class CreateDowntimeRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :downtime_records do |t|
      t.string :fors_werk
      t.string :fors_faufnr
      t.string :fors_faufpo
      t.string :fors_lnr
      t.references :machine, foreign_key: true
      t.string :pk_sch
      t.datetime :pk_datum
      t.string :pk_sch_std
      t.string :pk_sch_t
      t.references :craft, foreign_key: true
      t.float :pd_teb
      t.float :pd_stueck
      t.float :pd_auss_ruest
      t.float :pd_auss_prod
      t.string :pd_bemerk
      t.string :pd_user
      t.datetime :pd_erf_dat
      t.datetime :pd_von
      t.datetime :pd_bis
      t.references :downtime_code, foreign_key: true
      t.float :pd_std
      t.integer :pd_laenge
      t.string :pd_rf
      t.boolean :is_naturl

      t.timestamps
    end
  end
end