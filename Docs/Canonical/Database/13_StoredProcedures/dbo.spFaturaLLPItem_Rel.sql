SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spFaturaLLPItem_Rel]--'IAMTE201701004BRB'
	@FatCod varchar(17)
as
select 
	Nome_tp_Tx, 
	ifat.cd_tp_tx,Nome_Tp_Moeda,
	(Case when ifat.cd_tp_moeda = 'REL' then 'BRL' else ifat.cd_tp_moeda end) cd_tp_moeda ,DC, 
	(case when (DC = 'D' and Vlr_Org > 0 ) then Vlr_Org * -1 else Vlr_Org end) Vlr_Org, 
	(case when (DC = 'D' and Vlr_RS > 0 ) then Vlr_RS * -1 else Vlr_RS end)Vlr_RS, 
	Paridade, nome_tp_tx_ing,
	dbo.fbusca_containers_type(Num_Proc) [Containers]
from 
	item_fat IFAT with(nolock)
	join Tipo_Taxa TT with(nolock) on IFAT.Cd_Tp_Tx = TT.Cd_Tp_Tx
	join Tipo_Moeda TM with(nolock) on IFAT.Cd_tp_Moeda = TM.Cd_Tp_Moeda
where 
	fatCod=@FatCod






GO
