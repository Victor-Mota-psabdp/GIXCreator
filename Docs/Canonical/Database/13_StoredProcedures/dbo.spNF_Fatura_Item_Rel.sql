SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spNF_Fatura_Item_Rel]--1
	@ID INT
as
select 
	Nome_tp_Tx, NFI.cd_tp_tx,Nome_Tp_Moeda,NFI.cd_tp_moeda,DC, 
	(case when (DC = 'D' and Vlr_Org > 0 ) then Vlr_Org * -1 else Vlr_Org end) Vlr_Org, 
	(case when (DC = 'D' and Vlr_RS > 0 ) then Vlr_RS * -1 else Vlr_RS end) Vlr_RS, 
    Paridade, nome_tp_tx_ing,
	dbo.fbusca_containers_type(Num_Proc) [Containers]
from 
	NF_Fatura_Item NFI
	join Tipo_Taxa TT on NFI.Cd_Tp_Tx = TT.Cd_Tp_Tx
	join Tipo_Moeda TM on NFI.Cd_tp_Moeda = TM.Cd_Tp_Moeda
where 
	NFI.ID= @ID

GO
