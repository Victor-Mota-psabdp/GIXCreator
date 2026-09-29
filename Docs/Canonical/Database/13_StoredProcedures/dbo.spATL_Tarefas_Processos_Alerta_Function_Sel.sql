SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_Tarefas_Processos_Alerta_Function_Sel] 3995,40,'BOATN202203008BR'
CREATE procedure [dbo].[spATL_Tarefas_Processos_Alerta_Function_Sel] 
(

	@Id_Alert bigint,
	@ID_Task int,
	@JOB varchar(16) 
)
as

select 
	[dbo].[FRemoveCaracteresEspeciais_Enter] ([dbo].[fBusca_Alerta_Email_Doc_AutomaticoById_Alert] ('Assunto',@Id_Alert,@JOB)) [Assunto],
	[dbo].[fBusca_Alerta_Email_Doc_AutomaticoById_Alert] ('Message',@Id_Alert,@JOB) [Mensagem],
	[dbo].[fBusca_Alerta_Email_Doc_Automatico_Nome_DocumentoById_Alert] (@Id_Alert,@JOB) [CorpoMSG_Doc_Anexos],	
	LLp.cd_cliente			[Client Code],
	CS.APelido				[Client Name],
	[dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente,left(TP.Num_Proc,2) +'%') [Client Email],

	LLp.cd_cliente_master	[Client Master Code],
	CLI.Apelido				[Client Master Name],
	[dbo].[fBusca_Emal_Comunicacao](LLp.cd_cliente_master,'AG%')  [Client Master Email],

	LLP.Master				[Consol Reference],

	LLP.cd_fornecedor		[Supplier Code],
	FO.APelido				[Supplier Name],
	[dbo].[fBusca_Emal_Comunicacao](LLp.cd_fornecedor,left(TP.Num_Proc,2) +'%') [Supplier Email],

	PGRU.Cd_Pes_Grupo		[Group Code],
	GRU.Apelido				[Group Name], 
	TP.Dt_Previsao			[Prevision Date],
	TP.Dt_Conclusao			[Conclusion Date]
from Tarefas_Processos	TP	with(nolock)
	Join vwCliente_Alerta		LLP	with (nolock)on TP.Num_Proc = LLP.num_proc
	join pessoa					CS  with(nolock) on CS.Cd_Pes = LLP.cd_cliente
	left join pessoa					FO  with(nolock) on FO.Cd_Pes = LLP.cd_fornecedor

	join Pessoa_LLP				PGRU  with(nolock) on PGRU.Cd_Pes = LLP.cd_cliente
	left join Pessoa			GRU	with(nolock) on GRU.Cd_Pes = PGRU.cd_pes_grupo

	left join Pessoa			CLI with(nolock) on CLI.Cd_Pes = LLP.cd_cliente_master
where	
	tp.Num_Proc =@JOB and TP.ID_Task = @ID_Task
	


	


GO
