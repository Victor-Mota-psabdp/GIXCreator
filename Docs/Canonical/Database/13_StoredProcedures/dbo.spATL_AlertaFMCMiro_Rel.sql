SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_AlertaFMCMiro_Rel]

AS
SET NOCOUNT ON	
Declare  @TAB Table(
					[JOB] varchar (16),
					[ORDER] varchar(30),
					[Type] varchar(50),
					[Email] varchar(200),
					[ResponderPara] varchar(200)
					)

Insert into @TAB
select 
	Fatura_PC [JOB], 
	dbo.[fBusca_TipoDocCliente]('N',Fatura_PC,1) [ORDER],
	Case ID_Evento WHEN 'I' THEN '1-INVOICE' WHEN 'S' THEN '2-SEGURO' WHEN 'T' THEN '3-IMPOSTOS' WHEN 'F' THEN '4-COMPLEMENTAR' WHEN 'R' THEN '5-IMP. RECUPERAVEIS' WHEN 'K' THEN '6-ICMS COMPLEMENTAR' END [Type],
	'antonio.fabiospinasantos@fmc.com,isaias.castro@fmc.com,br.sao.sistemas@bdpint.com'[Email],
	'roberta.beltran@bdpint.com'[ResponderPara]
from 
	FMC_Miro with(nolock)
where 
	Dt_Envio >= '2013-04-01' and Dt_Alerta is NULL
	Group by [Fatura_PC],[ID_Evento],dbo.[fBusca_TipoDocCliente]('N',Fatura_PC,1)
	order by [ORDER],[JOB],[Type]
	
Update 
	@TAB
Set
	[Type] = right([Type],len([Type])-2)


select * from @TAB

GO
