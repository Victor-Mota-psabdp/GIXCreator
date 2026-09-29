SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[spSaldoDesembaracoAKZ_Rel]

AS

BEGIN
	
select 
	Apelido										Apelido,
	num_proc_hia								Num_Proc,
	sum(dbo.valor(vlr_pgto_rcto_hia,dc_hia))	Vlr_Pgto,
	Grp.Grupo									Grupo

from vwcxas

	Join Grupo GRP on substring(num_proc_hia,3,3)= GRP.grupo
	Join Pessoa PP on cd_pes_grupo = pp.cd_pes

where
	--Smart_Exp='AKZ'
	(GRP.grupo IN ('CAR','PAC','IFI','EKA','DEC','MPC','AKZ','NST','POW','SUR')) and (left(cd_Tp_Tx,1)='X' or cd_tp_Tx='DNF') 

group by

	Apelido,
	num_proc_hia,
	Grupo


END





GO
