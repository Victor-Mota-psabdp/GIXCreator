SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--[spCalculoNFComplementar3_Rel] 'IMSUR20101000101'
CREATE Procedure [dbo].[spCalculoNFComplementar3_Rel]
	(@Num_Proc varchar(16))
AS
	select 
		nome_tp_tx [Taxa],sum(vlr_item_custo) Valor 
	from 
		custo_cliente CC
		Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_tx
	where 
		num_proc=@num_proc
		and cc.cd_tp_tx not in (select cd_tp_tx from dbo.Tipo_Taxa_Custo_AKZO)
	group by 
		nome_tp_tx

UNION ALL

	select 
		'TOTAL',sum(vlr_item_custo) Valor 
	from 
		custo_cliente CC
		Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_tx
	where 
		num_proc=@num_proc
		and cc.cd_tp_tx not in (select cd_tp_tx from dbo.Tipo_Taxa_Custo_AKZO)


GO
