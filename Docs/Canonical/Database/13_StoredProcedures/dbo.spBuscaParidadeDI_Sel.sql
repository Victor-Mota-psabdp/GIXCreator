SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE Procedure [dbo].[spBuscaParidadeDI_Sel]
		@Num_Proc	Varchar(16),	
		@ITem		Varchar(5),
		@Num_Pedido	Varchar(50)
as

select right('000000' + Item,6),right('000000'+@Item,6),* from campo_processo CP
Join Pedido_Ship PS on PS.num_proc=CP.num_proc
Join Pedido PD on PD.cd_pedido=Ps.cd_pedido
where 
	id_campo=31
	and
	PS.num_proc=@Num_Proc
	--and	right('000000' + Item,6)=right('000000'+@Item,6)
--	and Num_Pedido=right('00000'+ @Num_Pedido,10)



--spBuscaParidadeDI_Sel 'IAFMC201111025BR','46004004','5'




GO
