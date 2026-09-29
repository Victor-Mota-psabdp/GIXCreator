SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*
spProdutoCliente_InsUPD
'',
'',
'',
''
*/
CREATE Procedure [dbo].[spPedidoAutoAkzoSur_InsUPD] 
		@Cd_Proc_Cliente	VarChar(30),
		@Cd_Cliente			VarChar(10),
		@Produto_Descr		VarChar(500),
		@NCM_Cliente		VarChar(8)
AS

Begin Transaction
	Declare @Cd_Prod	int
	Set @Cd_Prod=(select Isnull(max(cd_prod),0) from produto_cliente)
	SEt @Cd_Prod=@Cd_Prod+1
	
	if not exists (select cd_Proc_Cliente from produto_cliente where cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@cd_cliente)
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
						@Cd_Prod,
						@cd_Proc_Cliente,
						@Cd_Cliente,
						@Produto_Descr,
						@NCM_Cliente
					)
		end
	Else
		Begin
			Update
				Produto_cliente
			Set
				Produto_Descr=@Produto_Descr,
				NCM_Cliente=@NCM_Cliente
			Where
				cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@cd_cliente
		End
	


	if @@error <> 0
		Begin
			Rollback transaction
			return -1
		End

Commit Transaction


				
	









GO
