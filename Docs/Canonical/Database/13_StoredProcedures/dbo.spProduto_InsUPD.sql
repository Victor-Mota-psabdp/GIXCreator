SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--19/09 - incluido pra tirar o tab do produto description


CREATE Procedure [dbo].[spProduto_InsUPD] --'4W953','10NST','PTFE','39046110'
		@Cd_Prod  		VarChar(30),
		@Cd_Cliente		VarChar(10),
		@Produto_Descr	VarChar(500),
		@NCM_Cliente	VarChar(8)
AS

Begin Transaction
	set @NCM_Cliente = (select left(@NCM_Cliente,8))
	Declare @ID_Prod	int
	Set @Id_Prod=(select Isnull(max(cd_prod),0) from produto_cliente)
	SEt @id_Prod=@Id_Prod+1

	set @Produto_Descr = replace(@Produto_Descr,char(9),'')
	
	if not exists (select cd_Proc_Cliente from produto_cliente where cd_Proc_Cliente=@Cd_Prod and cd_cliente=@cd_cliente)
		Begin
			Insert into
				Produto_cliente
					(
						cd_prod,
						cd_Proc_Cliente,
						cd_Cliente,
						Produto_Descr,
						NCM_Cliente
					)
				values
					(
						@Id_Prod,
						@Cd_Prod,
						@Cd_Cliente,
						@Produto_Descr,
						@NCM_Cliente
					)
		end

	if @@error <> 0
		Begin
			Rollback transaction
			return -1
		End

Commit Transaction


				
	





GO
