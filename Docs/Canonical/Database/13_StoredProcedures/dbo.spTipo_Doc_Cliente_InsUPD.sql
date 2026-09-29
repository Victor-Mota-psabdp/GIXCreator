SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spTipo_Doc_Cliente_InsUPD] 
	@id_dc					int,
	@nome_dc				varChar(25),
	@smart_doc				VarChar(20),
	@data_obrigatoria		Char(1),
	@numero_obrigatorio		Char(1),
	@doc_anexo				Char(1),
	@replica				char(1),
	@House					char(1),
	@DMS_Code				varchar(5)
AS

Begin Transaction
	Declare @Id	int

	if not exists(select Id_dc from tipo_doc_cliente where id_dc=@id_dc)
		Begin
			Set @Id=(select Isnull(max(Id_dc),0) + 1 from tipo_doc_cliente)
		end
	Else
		Begin
			Set @Id=(select Id_dc from Tipo_doc_cliente where nome_dc=@nome_dc)
		End
	
	If @Id is null
	Begin 
		Set @Id=@id_dc
	End
	
	If @smart_doc = '' or @smart_doc is null
	Begin 
		Set @smart_doc =Null
	End
	
	If @DMS_Code = '' or @DMS_Code is null
	Begin 
		Set @DMS_Code = Null
	End
	
	if not exists (select ID_dc from Tipo_doc_cliente where Id_dc=@ID)
		Begin
			Insert into
				Tipo_doc_cliente
					(
						Id_dc,
						nome_dc,
						smart_doc,
						data_obrigatoria,
						numero_obrigatorio,
						doc_anexo,
						replica,
						House,
						DMS_Code
					)
				values
					(
						@id,
						@nome_dc,
						@smart_doc,
						@data_obrigatoria,
						@numero_obrigatorio,
						@doc_anexo,
						@replica,
						@House,
						@DMS_code
					)
		end
	Else
		Begin
			Update
				Tipo_doc_cliente
				Set
					nome_dc = @nome_dc,
					smart_doc = @smart_doc,
					data_obrigatoria = @data_obrigatoria,
					numero_obrigatorio = @numero_obrigatorio,
					doc_anexo = @doc_anexo,
					replica = @replica,
					DMS_Code = @DMS_Code,
					House = @House
			Where
				Id_dc=@ID
		End
	


	if @@error <> 0
		Begin
			Rollback transaction
			return -1
		End

Commit Transaction


				
	











GO
