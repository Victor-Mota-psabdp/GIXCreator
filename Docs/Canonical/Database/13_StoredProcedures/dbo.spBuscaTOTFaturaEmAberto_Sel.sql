SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spBuscaTOTFaturaEmAberto_Sel]
	@Num_Proc	Varchar(16)

as

select 
	sum(dbo.valor(abs(isnull(vlr_rs,vlr_org*isnull(par_moeda,1))),dc))  Saldo
from 
	item_fat ITF
	Left Join Paridade PAR on PAR.cd_tp_moeda=ITF.cd_tp_moeda and dt_par=convert(varchar(10),getdate(),103)
	Join Fatura FAT on FAT.fatcod=ITF.fatcod
where
	left(itf.fatcod,16)=@num_proc





GO
