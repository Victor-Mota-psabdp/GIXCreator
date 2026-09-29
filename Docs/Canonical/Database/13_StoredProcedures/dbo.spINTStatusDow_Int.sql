SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[spINTStatusDow_Int]
		@num_proc	Varchar(16)

as 
		
select DL_Chegada,BDPSmart_Descr,Data from pedido_ship PS with(nolock)
Join Data_pedidos DP with(nolock) on DP.cd_pedido=PS.cd_pedido
Join Pedido PD with(nolock) on PD.cd_pedido=PS.cd_pedido
Join Tipo_Referencia TF with(nolock) on TF.id_ref=DP.id_ref
where num_proc=@num_proc and BDPSmart_Descr is not null
group by DL_Chegada,BDPSmart_Descr,Data 


GO
