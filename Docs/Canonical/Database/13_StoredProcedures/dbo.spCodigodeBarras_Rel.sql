SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spCodigodeBarras_Rel]--'IMCSR201109252BR' 
	@Job varchar(16)
as

SELECT PO.NUMERO_PO_HIM numero, left(PO.Numero_PO_HIM,4) + ' - ' + nome_raz_soc nome
	FROM PO_HIM  PO
	join house_imp_mar HOU on HOU.num_proc_him = PO.num_proc_him
	join pessoa P on P.cd_pes = HOU.cd_consig_him
where PO.num_proc_him =  @Job
AND PO.ID_DC = 140
GO
