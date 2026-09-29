SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATL_Valida_Produto_Sel 'P000031844','IMSWB201901034BR','CAB381-20'

CREATE procedure [dbo].[spATL_Valida_Produto_Sel]
	@cd_cliente varchar(10),
	@Num_proc varchar(16),
	@cd_proc_cliente varchar(30)
as

select cd_prod from produto_cliente join pedido_ship PS on cd_produto=cd_prod  
where right('000000000000000000' + cd_proc_cliente,18) =
right('000000000000000000' +  @cd_proc_cliente,18) 
 and cd_cliente=@cd_cliente
 and num_proc =@Num_proc
 

	

GO
