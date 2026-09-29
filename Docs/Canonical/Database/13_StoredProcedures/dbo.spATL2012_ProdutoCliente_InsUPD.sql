SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Stored criada pra ser usada no ATL 2012 DLL - DLL_ProdutoCliente


--delete produto_cliente where cd_proc_cliente = 'Teste'
--select * from produto_cliente where cd_proc_cliente = 'Teste'
CREATE Procedure [dbo].[spATL2012_ProdutoCliente_InsUPD]--'0','Teste','GRUPO HYUNDAI','tet','tes',Null

		@cd_prod			int,
		@Cd_Proc_Cliente	VarChar(30),
		@Apelido			VarChar(20),
		@Produto_Descr		VarChar(500),
		@NCM_Cliente		VarChar(8),
		@cd_Prod_ret		int  OUTPUT
AS

Begin Transaction
	declare @cd_cliente varchar(10)
	set @cd_cliente = (select cd_pes from pessoa where apelido = @Apelido)
	
	IF @cd_prod = 0
		BEGIN			
			Set @Cd_Prod=(select Isnull(max(cd_prod),0) from produto_cliente)
			Set @Cd_Prod=@Cd_Prod+1
	
			if not exists (select cd_Proc_Cliente from produto_cliente where cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@cd_cliente)
				Begin
					if exists (select Produto_Descr from produto_cliente where Produto_Descr=@Produto_Descr and cd_cliente=@cd_cliente)
						begin
							set @Produto_Descr = @Produto_Descr + ' (' + @cd_Proc_Cliente + ')'
						end
					if NOT exists (select Produto_Descr from produto_cliente where Produto_Descr=@Produto_Descr and cd_cliente=@cd_cliente)
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
						
						set @cd_Prod_ret = @cd_prod
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

					set @cd_Prod_ret = (select cd_prod from Produto_cliente Where cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@cd_cliente)
				End
		END
	ELSE
			Begin
					Update
						Produto_cliente
					Set
						Produto_Descr=@Produto_Descr,
						NCM_Cliente=@NCM_Cliente			
					Where
						cd_Prod = @cd_prod

					set @cd_Prod_ret = @cd_prod
			End	
	
	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
Commit Transaction












GO
