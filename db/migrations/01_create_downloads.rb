Sequel.migration do
  change do
    create_table(:downloads) do
      primary_key :id
      String :path
      Integer :count, default: 0
    end
  end
end
