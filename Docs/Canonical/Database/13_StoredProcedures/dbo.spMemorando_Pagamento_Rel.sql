SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spMemorando_Pagamento_Rel]--'IMLAN201707002BR'
(
	@Num_Proc varchar(16),
	@cd_usuario varchar(6)
)
As		


select 
	UPPER(AR.Nome_Armador) Nome_Armador,
	JOB.MAWB [ReservaHBL],
	'BDP SOUTH AMERICA LTDA' [Exportador ou Importador],
	JOB.VESSEL [Navio],
	JOB.ETA [Ets / Eta],
	UPPER(ORG.Nome_Local) [Origem],
	UPPER(DST.Nome_Local) [Destino],
	
	--UPPER(TT.Nome_Tp_Tx)Nome_Tp_Tx,
	--CTA.CD_TP_MOEDA,
	--CTA.Vlr_Org_HIA
	
	(case when CTA.CD_TP_MOEDA = 'REL' then 
		UPPER(TT.Nome_Tp_Tx) + ': R$' + CONVERT(varchar(20),CTA.Vlr_Org_HIA)
	else	
		UPPER(TT.Nome_Tp_Tx) + ':'+ CTA.CD_TP_MOEDA + CONVERT(varchar(20),CTA.Vlr_Org_HIA)
	 end) Nome_Tp_Tx,
	 
	 U.Nome_Usuario,
	 (case when @cd_usuario = 'talves' then 'CPF: 347.846.868-00'
		else
		(case when @cd_usuario = 'dsf' then 'CPF: 404.079.878-35 '
		else ''		
	end)end) cpf
from vwHouse_Imp JOB with(nolock)
	join vwcta_Cte CTA on CTA.Num_Proc_HIA = JOB.Num_Proc
	JOIN Tipo_Taxa TT on TT.Cd_Tp_Tx = CTA.Cd_Tp_Tx
	JOIN Localidade ORG ON ORG.Cd_Local = JOB.Cd_Org
	JOIN Localidade DST ON DST.Cd_Local = JOB.Cd_Dst
	LEFT JOIN Armador AR ON AR.Cd_Armador = JOB.Cd_Armador
	left join Usuario U on u.cd_usuario = @cd_usuario
where
	JOB.Num_Proc = @Num_Proc
	AND CTA.DC_HIA = 'D'
	

GO
