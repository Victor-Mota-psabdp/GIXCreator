SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[spATLINT_JSON_Braskem_IntegrarFollowUP_Sel]
(
	@ID_IntegrarFollowUP		bigint,
	@processoNumero				varchar(255),
	@Num_Proc					varchar(255),
	@Tipo						char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
Z /// Verifica Nome X Codigo
sp_help JSON_Braskem_Atualizar
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		Select
			S.Id_IntegrarFollowUP	 [Internal Code],
			S.hawb,
			S.deal,
			S.processoNumero,
			S.nomeNavio,
			S.nomeNavioTransbordo,
			S.origin,
			S.destination,
			S.freeTime,
			S.referenciaArmador,
			S.dataAtracacao,
			S.dataEmbarque,
			S.numeroCeMaster,
			S.dataEta,
			S.dataEtd,
			S.dataPrevEtd,
			S.dataPrevEta,
			S.dataPresencaCarga,
			S.dataEfetivaColeta,
			S.dataPrevisaoColeta,
			S.pesoBruto,
			S.volumeCubico,
			S.haCargaImo,
			S.observacaoRodoviario,
			S.dataGreenLight,
			S.dataChegadaArmazem,
			S.dataChegadaDestino,
			S.tipoContratacaoFrete,
			S.Num_Proc,
			S.Dt_Ins					[Insert Date],
			S.Dt_Sent					[Sent Date],
			S.Message
		from 
			ATL_INT.dbo.JSON_Braskem_IntegrarFollowUP S with(nolock)

	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		Select
			S.Id_IntegrarFollowUP	 [Internal Code],
			S.hawb,
			S.deal,
			S.processoNumero,
			S.nomeNavio,
			S.nomeNavioTransbordo,
			S.origin,
			S.destination,
			S.freeTime,
			S.referenciaArmador,
			S.dataAtracacao,
			S.dataEmbarque,
			S.numeroCeMaster,
			S.dataEta,
			S.dataEtd,
			S.dataPrevEtd,
			S.dataPrevEta,
			S.dataPresencaCarga,
			S.dataEfetivaColeta,
			S.dataPrevisaoColeta,
			S.pesoBruto,
			S.volumeCubico,
			S.haCargaImo,
			S.observacaoRodoviario,
			S.dataGreenLight,
			S.dataChegadaArmazem,
			S.dataChegadaDestino,
			S.tipoContratacaoFrete,
			S.Num_Proc,
			S.Dt_Ins					[Insert Date],
			S.Dt_Sent					[Sent Date],
			S.Message
		from 
			ATL_INT.dbo.JSON_Braskem_IntegrarFollowUP S with(nolock)
		where 
			S.ID_IntegrarFollowUP = @ID_IntegrarFollowUP
			
	End

if @Tipo = 'N' 
	Begin
		Select
			S.Id_IntegrarFollowUP	 [Internal Code],
			S.hawb,
			S.deal,
			S.processoNumero,
			S.nomeNavio,
			S.nomeNavioTransbordo,
			S.origin,
			S.destination,
			S.freeTime,
			S.referenciaArmador,
			S.dataAtracacao,
			S.dataEmbarque,
			S.numeroCeMaster,
			S.dataEta,
			S.dataEtd,
			S.dataPrevEtd,
			S.dataPrevEta,
			S.dataPresencaCarga,
			S.dataEfetivaColeta,
			S.dataPrevisaoColeta,
			S.pesoBruto,
			S.volumeCubico,
			S.haCargaImo,
			S.observacaoRodoviario,
			S.dataGreenLight,
			S.dataChegadaArmazem,
			S.dataChegadaDestino,
			S.tipoContratacaoFrete,
			S.Num_Proc,
			S.Dt_Ins					[Insert Date],
			S.Dt_Sent					[Sent Date],
			S.Message
		from 
			ATL_INT.dbo.JSON_Braskem_IntegrarFollowUP S with(nolock)
		where 
			S.Num_Proc = @Num_Proc
	End

if @Tipo = 'O'
	Begin
		Select
			S.Id_IntegrarFollowUP	 [Internal Code],
			S.hawb,
			S.deal,
			S.processoNumero,
			S.nomeNavio,
			S.nomeNavioTransbordo,
			S.origin,
			S.destination,
			S.freeTime,
			S.referenciaArmador,
			S.dataAtracacao,
			S.dataEmbarque,
			S.numeroCeMaster,
			S.dataEta,
			S.dataEtd,
			S.dataPrevEtd,
			S.dataPrevEta,
			S.dataPresencaCarga,
			S.dataEfetivaColeta,
			S.dataPrevisaoColeta,
			S.pesoBruto,
			S.volumeCubico,
			S.haCargaImo,
			S.observacaoRodoviario,
			S.dataGreenLight,
			S.dataChegadaArmazem,
			S.dataChegadaDestino,
			S.tipoContratacaoFrete,
			S.Num_Proc,
			S.Dt_Ins					[Insert Date],
			S.Dt_Sent					[Sent Date],
			S.Message
		from 
			ATL_INT.dbo.JSON_Braskem_IntegrarFollowUP S with(nolock)
		where 
			S.Num_Proc = @Num_Proc and S.Num_Proc is not null
	End

if @Tipo = 'P'
	Begin
		Select
			S.Id_IntegrarFollowUP	 [Internal Code],
			S.hawb,
			S.deal,
			S.processoNumero,
			S.nomeNavio,
			S.nomeNavioTransbordo,
			S.origin,
			S.destination,
			S.freeTime,
			S.referenciaArmador,
			S.dataAtracacao,
			S.dataEmbarque,
			S.numeroCeMaster,
			S.dataEta,
			S.dataEtd,
			S.dataPrevEtd,
			S.dataPrevEta,
			S.dataPresencaCarga,
			S.dataEfetivaColeta,
			S.dataPrevisaoColeta,
			S.pesoBruto,
			S.volumeCubico,
			S.haCargaImo,
			S.observacaoRodoviario,
			S.dataGreenLight,
			S.dataChegadaArmazem,
			S.dataChegadaDestino,
			S.tipoContratacaoFrete,
			S.Num_Proc,
			S.Dt_Ins					[Insert Date],
			S.Dt_Sent					[Sent Date],
			S.Message
		from 
			ATL_INT.dbo.JSON_Braskem_IntegrarFollowUP S with(nolock)		
		Where
			S.Dt_Sent is null
		Order by 
			S.Id_IntegrarFollowUP
	End
	

if @Tipo = 'X'
	Begin
	--BA03202200955
		select distinct
			NULL							[Internal Code],
			HOU.HAWB						hawb,
			NULL							deal,
			right(PO8.Numero_PO,9)			processoNumero,
			Case when left(HOU.Num_Proc,2) = 'IA' then NULL else
			HOU.VESSEL		end				nomeNavio,
			NULL							nomeNavioTransbordo,
			Case when left(HOU.Num_Proc,2) = 'IA' then
				
					isnull(ORGDP.Cd_Dst, ORG.CD_PAIS + ORG.IATACODE)
				else 
					ORG.CD_PAIS + ORG.SCAC end	origin,		
			Case when left(HOU.Num_Proc,2) = 'IA' then
					isnull(DSTDP.Cd_Dst,DST.CD_PAIS + DST.IATACODE)
				else 
					DST.CD_PAIS + DST.SCAC end	destination,
			NULL							freeTime,
			'25439'							referenciaArmador,
			HOU.ATA							dataAtracacao,
			HOU.ATD							dataEmbarque,
			HOU.MAWB						numeroCeMaster,
			HOU.ETA							dataEta,
			HOU.ETD							dataEtd,
			HOU.ETD							dataPrevEtd,--Data de previsão ETD; (aba principal)	dataPrevEtd	QUANDO NARWAL DISPONIBILIZAR CAMPO, SERÁ UTILIZADO MESMO CAMPO DE ETD
			HOU.ETA							dataPrevEta,--Data de previsão ETA; (aba principal)	dataPrevEta	QUANDO NARWAL DISPONIBILIZAR CAMPO, SERÁ UTILIZADO MESMO CAMPO DE ETA
			TP277.Dt_Conclusao				dataPresencaCarga,--277	Recepção no CCT
			TP10.Dt_Conclusao				dataEfetivaColeta,
			NULL							dataPrevisaoColeta,			--Data previsão de coleta;	Não se aplica por não ser enviado	 NÃO IRÁ MIGRAR. SERÁ ATUALIZADO PELO DESPACHANTE
			HOU.Peso_Bruto					pesoBruto,
			HOU.Peso_Cubado					volumeCubico,
			(case when CP185.Campo_Dados = '1' then convert(bit,1) else convert(bit,0) end) haCargaImo,
			HOU.Notas						observacaoRodoviario,
			TP50.Dt_Conclusao				dataGreenLight,
			TP276.Dt_Conclusao				dataChegadaArmazem,--276	Chegada no Warehouse
			HOU.ATA							dataChegadaDestino,
			NULL							tipoContratacaoFrete,			
			NULL							[Insert Date],
			NULL							[Sent Date],
			NULL							Message,
			HOU.Num_Proc					Num_Proc
			--,LLP.cd_pes_grupo,HOU.cd_consig
			--,PO8.Numero_PO					chave
			--,left(PO8.Numero_PO,4)			filial
			from vwHouse_Imp				HOU		with(nolock)
			join Pessoa_LLP				LLP		with(nolock) on LLP.cd_pes = HOU.cd_consig and cd_pes_grupo = 'P000000438'
			join vwPO_ALL				PO8		with(nolock) on PO8.NUm_proc = HOU.Num_Proc and PO8.ID_DC = 8
			join Exchange				EXC		with(nolock) on HOU.NUm_proc COLLATE DATABASE_DEFAULT = EXC.ExcProcesso  COLLATE DATABASE_DEFAULT	
			left join Localidade		ORG		with(nolock) on ORG.cd_local = HOU.cd_Org
			left join Localidade		DST		with(nolock) on DST.cd_local = HOU.cd_dst			
			left join Campo_Processo	CP185	with(nolock) on CP185.NUm_proc = HOU.Num_Proc and CP185.Id_Campo = 185
			
			left join Tarefas_Processos	TP277	with(nolock) on TP277.NUm_proc = HOU.Num_Proc and TP277.ID_Task = 277
			--277	Recepção no CCT
			left join Tarefas_Processos	TP10	with(nolock) on TP10.NUm_proc = HOU.Num_Proc and TP10.ID_Task = 10
			left join Tarefas_Processos	TP50	with(nolock) on TP50.NUm_proc = HOU.Num_Proc and TP50.ID_Task = 50
			left join Tarefas_Processos	TP276	with(nolock) on TP276.NUm_proc = HOU.Num_Proc and TP276.ID_Task = 276
			--276	Chegada no Warehouse
			left join dbo.De_Para ORGDP WITH(NOLOCK) ON ORGDP.Cd_Cliente='P000000438' AND ORGDP.Cd_Tipo = '34' and ORGDP.Cd_Org=ORG.CD_PAIS + ORG.IATACODE
			left join dbo.De_Para DSTDP WITH(NOLOCK) ON DSTDP.Cd_Cliente='P000000438' AND DSTDP.Cd_Tipo = '34' and DSTDP.Cd_Org=DST.CD_PAIS + DST.IATACODE
		Where
			--HOU.Num_Proc = 'IABRM202506041BR' and
			HOU.Num_Proc not like  'IAATL202%'
			--IA E IM			
			AND 
			EXC.ExcDataAlt >= DateAdd(HOUR,-2,getdate()) 			
			--EXC.ExcDataAlt >= DateAdd(day,-3,getdate()) 
			
	
	End
--	select * from Exchange HOU where ExcProcesso like 'IABRM20241%'
--		select * from vwHouse_Imp HOU where num_proc like 'IABRM20241%'
--		se
	
--select * from vwPO_ALL where num_proc like 'IABRM20241%' and id_dc = 8
	
	/*

	select * from vwHouse_Imp HOU where num_proc like 'IABRM20241%'
	
select * from vwPO_ALL where num_proc like 'IABRM20241%'
	
			select * from pessoa where apelido like 'GRUPO BRASKEM%'
select * from vwHouse_Imp HOU
	join Pessoa_LLP LLP on LLP.cd_pes = HOU.cd_consig
where
	num_proc = 'IMBRM202407001BR'
	LLP.cd_pes_grupo = 'P000000438'
order by convert(datetime,HOU.Dt_Emis,105) 

select * from vwPO_ALL where num_proc = 'IMBRM202407001BR'

select * from Pessoa where num_cpf_cnpj = '42150391004087'
select * from Endereco where cd_pes in ('P000016568','P000016579')
'42150391004087'
select * from localidade where nome_local like '%Paranagua%'
update PO_HIM set numero_po_him = '202401167' where num_proc_HIM = 'IMBRM202407001BR'	
	
	*/

if @Tipo = 'I'
	Begin
		Select
			S.Id_IntegrarFollowUP	 [Internal Code],
			S.hawb,
			S.deal,
			S.processoNumero,
			S.nomeNavio,
			S.nomeNavioTransbordo,
			S.origin,
			S.destination,
			S.freeTime,
			S.referenciaArmador,
			S.dataAtracacao,
			S.dataEmbarque,
			S.numeroCeMaster,
			S.dataEta,
			S.dataEtd,
			S.dataPrevEtd,
			S.dataPrevEta,
			S.dataPresencaCarga,
			S.dataEfetivaColeta,
			S.dataPrevisaoColeta,
			S.pesoBruto,
			S.volumeCubico,
			S.haCargaImo,
			S.observacaoRodoviario,
			S.dataGreenLight,
			S.dataChegadaArmazem,
			S.dataChegadaDestino,
			S.tipoContratacaoFrete,
			S.Num_Proc,
			S.Dt_Ins					[Insert Date],
			S.Dt_Sent					[Sent Date],
			S.Message
		from 
			ATL_INT.dbo.JSON_Braskem_IntegrarFollowUP S with(nolock)
		where
			S.dt_ins > getdate() -120
	End


	

GO
