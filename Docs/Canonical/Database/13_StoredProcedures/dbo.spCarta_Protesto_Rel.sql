SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--terminal operador - operador portuario
--armador - carrier
--refe adicionais - agent
--terminal

--select * from Tipo_Campo_Cliente where Descr_Campo like '%Operador Portuário%'
--[spCarta_Protesto_Rel]'IMSOL201908014BR'
CREATE procedure [dbo].[spCarta_Protesto_Rel]
(
	@Processo	varchar(16)
)
As

--declare @Processo	varchar(16)
--set @Processo = 'IMSOL201807114BR'

	Select
		isnull(TERM.Nome_Terminal,'Sem Terminal no JOB')	Terminal,
		ARM.nome_armador	Carrier,
		isnull(AGENT.Nome_Raz_Soc,'Sem Agent no JOB')	Agent,	
		--TOPE.Descricao_OP  [Operador Portuario],
		--'Operador Portuario'  [Operador Portuario],
		isnull(TOPE.Descricao_OP,'Sem Operador Portuario no JOB') [Operador Portuario],
		
		'IMP. ' + Consig.Nome_Raz_Soc	Importador,
		'N/REF: ' + HOU.Num_Proc_HIM + ' - ' + isnull(dbo.fBusca_Docs_PO_Modal(@Processo,1),'') NREF,
		'MBL: ' + ISNULL(HOU.MAWB_HIM,'')		MBL,
		'HBL: ' + ISNULL(HOU.HAWB_HIM,'')		HBL,	
		'CONTAINER: ' + ISNULL(dbo.fBusca_DescrContainers(@Processo),'') Containers,
		'NAVIO: ' + isnull(HOU.Navio_HIM,'')+ '- V: ' + isnull(HOU.Viagem_HIM,'') Navio,		
		'CONTATO: BR.SSZ.SMV@BDPINT.COM' CONTATO,
		
		'Prezados Senhores:
		Atendendo aos preceitos do artigo 756, e parágrafo do decreto Lei nº 1.608 de 18/09/39,combinado com o Artigo 1218, item XIV – Código de Processo Civil Anterior, mantido em vigor pelo Artigo 754 do Novo Diploma Legal – Código Civil – Lei nº 10.406 de 10.01.2002, vigorando em 11/01/2003, pedimos vênia para considerarem esta carta como PROTESTO, a título de antecipação, pelas avarias e/ou indícios de violação ocasionados à carga e, se for o caso, encaminharemos a V.S.as., oportunamente, a respectiva nota de débito.
		
		Sem mais.' Texto,
		
		PG.Apelido Grupo		
	from
		House_Imp_Mar		HOU		with(nolock)
		Left Join LLP_Imp_Mar	LLP		with(nolock) on LLP.Num_Proc_LIM = HOU.Num_Proc_HIM
		Left Join JOB_Imp_Mar	JOB		with(nolock) on JOB.Num_Proc_HIM = HOU.Num_Proc_HIM  
		Left Join Pessoa		Consig	with(nolock) on HOU.Cd_Consig_HIM = Consig.Cd_Pes
		Left Join Terminal		TERM	with(nolock) on TERM.cd_terminal = LLP.cd_terminal
		left join Armador		ARM 	with(nolock) on ARM.Cd_Armador = JOB.Cd_Armador
		Left Join Pessoa		AGENT	with(nolock) on AGENT.cd_pes = JOB.Cd_Agente
		Left Join Campo_Processo	OP	with(nolock) on OP.Num_Proc = HOU.Num_Proc_HIM  and op.id_campo = 139
		left join Tipo_Operador_Portuario TOPE 	with(nolock) on TOPE.ID_OP = OP.CAMPO_DADOS
		left join Pessoa		P	with(nolock) on p.Cd_Pes = HOU.Cd_Consig_HIM
		Left join Pessoa_LLP	PL	with(nolock) on HOU.Cd_Consig_HIM = PL.Cd_Pes
		Left Join  Grupo		G	with(nolock) on G.cd_pes_grupo=PL.cd_pes_grupo
		Left Join  pessoa		PG	with(nolock) on PG.cd_pes=PL.Cd_Pes_Grupo
	where 
		HOU.Num_Proc_HIM = @Processo



GO
