Sequel.migration do
  change do
    create_table(:people) do
      primary_key :id
      DateTime :arrival_time
    end
  end
end
