class CreatePamItems < ActiveRecord::Migration[5.0]
  def change
    create_table :pam_items do |t|
      t.string :pa_no
      t.string :description
      t.integer :qty
      t.float :total_cost
      t.string :applicant
      t.datetime :applicant_date
      t.string :supplier
      t.string :sap_no
      t.string :arrive_date
      t.boolean :final_release, default: false
      t.string :po_no
      t.float :po_cost
      t.boolean :invoice_prepared, default: false
      t.float :invoice_amount
      t.string :completed_date
      t.string :completed_id
      t.string :completed_status
      t.float :completed_amount
      t.boolean :booking_status, default: false
      t.float :final_cost
      t.references :pam_list, foreign_key: true

      t.timestamps
    end
  end
end
