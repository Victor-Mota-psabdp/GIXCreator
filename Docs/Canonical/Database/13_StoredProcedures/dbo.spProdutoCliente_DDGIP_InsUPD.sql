SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spProdutoCliente_DDGIP_InsUPD] 
		@Cd_Proc_Cliente	VarChar(30),
		@Cd_Cliente			VarChar(10),
		@Produto_Descr		VarChar(500),
		@NCM_Cliente		VarChar(8),
		@MEM_DESCRICAOPORTUGUES		VarChar(8000)
AS

Begin Transaction

	set @Produto_Descr = replace(@Produto_Descr,char(9),'')
	
	if not exists (select cd_Proc_Cliente from produto_cliente_DDGIP where cd_Proc_Cliente=@cd_Proc_Cliente and cd_cliente=@cd_cliente)
		BEGIN			
			Insert into
				Produto_cliente_DDGIP
					(						
						cd_Proc_Cliente,
						cd_Cliente,
						Produto_Descr,
						NCM_Cliente,
						MEM_DESCRICAOPORTUGUES
					)
				values
					(						
						@cd_Proc_Cliente,
						@Cd_Cliente,
						@Produto_Descr,
						@NCM_Cliente,
						@MEM_DESCRICAOPORTUGUES
					)			
		END
	Else
		BEGIN
			Update
				Produto_cliente_DDGIP
			Set
				Produto_Descr=@Produto_Descr,
				NCM_Cliente=@NCM_Cliente,
				MEM_DESCRICAOPORTUGUES = @MEM_DESCRICAOPORTUGUES
			Where
				cd_Proc_Cliente=@cd_Proc_Cliente 
				and cd_cliente=@cd_cliente
			
		END
	
 

	if @@error <> 0
		Begin
			Rollback transaction
			return -1
		End

Commit Transaction











GO
