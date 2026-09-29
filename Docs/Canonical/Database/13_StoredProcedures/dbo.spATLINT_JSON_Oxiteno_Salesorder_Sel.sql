SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from ATL_INT.dbo.JSON_Oxiteno_Salesorder where (message like '%Order Created% Group:GRUPO OXITENO%' or message is null)
CREATE procedure [dbo].[spATLINT_JSON_Oxiteno_Salesorder_Sel]--'','','Q'
(
	@ID_Salesorder bigint,
	@numero_pedido varchar(200),
	@Tipo char(1)
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
sp_help Tipo_Modal
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 
			S.ID_Salesorder [Internal Code],
			S.numero_pedido,
			S.cnpj,
			S.data_pedido_venda,
			S.cliente_codigo,
			S.cliente_nome,
			S.observacoes,
			S.pedido_cliente,
			S.forma_pagamento,
			S.incoterm,
			S.local_origem,
			S.local_destino,
			S.moeda,
			S.tipo_equipamento,
			S.tipo_carga,
			S.pais_destino,
			S.modal,
			S.valor_total,
			S.seller,
			S.cliente_end,
			S.cliente_cep,
			S.cliente_cidade,
			S.cliente_pais,
			S.qtd_equipamento,
			[dbo].[fBusca_Data_Liberacao_JSON_Oxiteno_Salesorder_Line](S.ID_Salesorder) Dt_Pedido,
			S.[Message] Message,
			
			S.cd_pedido,
			S.dt_ins				[Received Date],
			S.Dt_Ins_Pedido			[Order Created Date],
			S.Dt_Ins_JOB			[JOB Created Date],
			S.Num_Proc				[JOB],
			--Informations Pre Defined
			P.Cd_Pes					[Group Code],
			P.Apelido					[Group Name],
			TP.cd_Tp_Pedido				[Type Code],
			TP.Nome_Tp_Pedido			[Type Name],
			TSP.Cd_Tp_Status_Pedido		[Status Code],
			TSP.Nome_Tp_Status_Pedido	[Status Name],
			PA.Cd_Pais					[Origin Code],
			PA.Nome_Pais				[Origin Name]
		from 
			ATL_INT.dbo.JSON_Oxiteno_Salesorder S with(nolock)
			join Pessoa P with(nolock) on P.cd_pes = 'P21128'
			join Tipo_Pedido TP with(nolock) on TP.Cd_tp_Pedido = '3'
			join Tipo_Status_Pedido TSP with(nolock) on TSP.Cd_Tp_Status_Pedido = 'O'
			join Pais PA with(nolock) on PA.Cd_Pais = 'BR'
			
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			S.ID_Salesorder [Internal Code],
			S.numero_pedido,
			S.cnpj,
			S.data_pedido_venda,
			S.cliente_codigo,
			S.cliente_nome,
			S.observacoes,
			S.pedido_cliente,
			S.forma_pagamento,
			S.incoterm,
			S.local_origem,
			S.local_destino,
			S.moeda,
			S.tipo_equipamento,
			S.tipo_carga,
			S.pais_destino,
			S.modal,
			S.valor_total,
			S.seller,
			S.cliente_end,
			S.cliente_cep,
			S.cliente_cidade,
			S.cliente_pais,
			S.qtd_equipamento,
			[dbo].[fBusca_Data_Liberacao_JSON_Oxiteno_Salesorder_Line](S.ID_Salesorder) Dt_Pedido,
			S.[Message] Message,
			S.cd_pedido,
			S.dt_ins [Received Date],
			S.Dt_Ins_Pedido [Order Created Date],
			S.Dt_Ins_JOB			[JOB Created Date],
			S.Num_Proc				[JOB],
			--Informations Pre Defined
			P.Cd_Pes					[Group Code],
			P.Apelido					[Group Name],
			TP.cd_Tp_Pedido				[Type Code],
			TP.Nome_Tp_Pedido			[Type Name],
			TSP.Cd_Tp_Status_Pedido		[Status Code],
			TSP.Nome_Tp_Status_Pedido	[Status Name],
			PA.Cd_Pais					[Origin Code],
			PA.Nome_Pais				[Origin Name]
		from 
			ATL_INT.dbo.JSON_Oxiteno_Salesorder S with(nolock)
			join Pessoa P with(nolock) on P.cd_pes = 'P21128'
			join Tipo_Pedido TP with(nolock) on TP.Cd_tp_Pedido = '3'
			join Tipo_Status_Pedido TSP with(nolock) on TSP.Cd_Tp_Status_Pedido = 'O'
			join Pais PA with(nolock) on PA.Cd_Pais = 'BR'
		where 
			ID_Salesorder = @ID_Salesorder
	End

if @Tipo = 'N' 
	Begin
		select 
			S.ID_Salesorder [Internal Code],
			S.numero_pedido,
			S.cnpj,
			S.data_pedido_venda,
			S.cliente_codigo,
			S.cliente_nome,
			S.observacoes,
			S.pedido_cliente,
			S.forma_pagamento,
			S.incoterm,
			S.local_origem,
			S.local_destino,
			S.moeda,
			S.tipo_equipamento,
			S.tipo_carga,
			S.pais_destino,
			S.modal,
			S.valor_total,
			S.seller,
			S.cliente_end,
			S.cliente_cep,
			S.cliente_cidade,
			S.cliente_pais,
			S.qtd_equipamento,
			[dbo].[fBusca_Data_Liberacao_JSON_Oxiteno_Salesorder_Line](S.ID_Salesorder) Dt_Pedido,
			S.[Message] Message,
			S.cd_pedido,
			S.dt_ins [Received Date],
			S.Dt_Ins_Pedido [Order Created Date],
			S.Dt_Ins_JOB			[JOB Created Date],
			S.Num_Proc				[JOB],
			--Informations Pre Defined
			P.Cd_Pes					[Group Code],
			P.Apelido					[Group Name],
			TP.cd_Tp_Pedido				[Type Code],
			TP.Nome_Tp_Pedido			[Type Name],
			TSP.Cd_Tp_Status_Pedido		[Status Code],
			TSP.Nome_Tp_Status_Pedido	[Status Name],
			PA.Cd_Pais					[Origin Code],
			PA.Nome_Pais				[Origin Name]
		from 
			ATL_INT.dbo.JSON_Oxiteno_Salesorder S with(nolock)
			join Pessoa P with(nolock) on P.cd_pes = 'P21128'
			join Tipo_Pedido TP with(nolock) on TP.Cd_tp_Pedido = '3'
			join Tipo_Status_Pedido TSP with(nolock) on TSP.Cd_Tp_Status_Pedido = 'O'
			join Pais PA with(nolock) on PA.Cd_Pais = 'BR'
		where 
			numero_pedido = @numero_pedido
	End

if @Tipo = 'O'
	Begin
		select 
			S.ID_Salesorder [Internal Code],
			S.numero_pedido,
			S.cnpj,
			S.data_pedido_venda,
			S.cliente_codigo,
			S.cliente_nome,
			S.observacoes,
			S.pedido_cliente,
			S.forma_pagamento,
			S.incoterm,
			S.local_origem,
			S.local_destino,
			S.moeda,
			S.tipo_equipamento,
			S.tipo_carga,
			S.pais_destino,
			S.modal,
			S.valor_total,
			S.seller,
			S.cliente_end,
			S.cliente_cep,
			S.cliente_cidade,
			S.cliente_pais,
			S.qtd_equipamento,
			[dbo].[fBusca_Data_Liberacao_JSON_Oxiteno_Salesorder_Line](S.ID_Salesorder) Dt_Pedido,
			S.[Message] Message,
			S.cd_pedido,
			S.dt_ins [Received Date],
			S.Dt_Ins_Pedido [Order Created Date],
			S.Dt_Ins_JOB			[JOB Created Date],
			S.Num_Proc				[JOB],
			--Informations Pre Defined
			P.Cd_Pes					[Group Code],
			P.Apelido					[Group Name],
			TP.cd_Tp_Pedido				[Type Code],
			TP.Nome_Tp_Pedido			[Type Name],
			TSP.Cd_Tp_Status_Pedido		[Status Code],
			TSP.Nome_Tp_Status_Pedido	[Status Name],
			PA.Cd_Pais					[Origin Code],
			PA.Nome_Pais				[Origin Name]
		from 
			ATL_INT.dbo.JSON_Oxiteno_Salesorder S with(nolock)
			join Pessoa P with(nolock) on P.cd_pes = 'P21128'
			join Tipo_Pedido TP with(nolock) on TP.Cd_tp_Pedido = '3'
			join Tipo_Status_Pedido TSP with(nolock) on TSP.Cd_Tp_Status_Pedido = 'O'
			join Pais PA with(nolock) on PA.Cd_Pais = 'BR'
		where 
			numero_pedido = @numero_pedido and S.Num_Proc is not null
	End

if @Tipo = 'P'
	Begin
		select 
			S.ID_Salesorder [Internal Code],
			S.numero_pedido,
			S.cnpj,
			S.data_pedido_venda,
			S.cliente_codigo,
			S.cliente_nome,
			S.observacoes,
			S.pedido_cliente,
			S.forma_pagamento,
			S.incoterm,
			S.local_origem,
			S.local_destino,
			S.moeda,
			S.tipo_equipamento,
			S.tipo_carga,
			S.pais_destino,
			S.modal,
			S.valor_total,
			S.seller,
			S.cliente_end,
			S.cliente_cep,
			S.cliente_cidade,
			S.cliente_pais,
			S.qtd_equipamento,
			[dbo].[fBusca_Data_Liberacao_JSON_Oxiteno_Salesorder_Line](S.ID_Salesorder) Dt_Pedido,
			S.[Message] Message,
			S.cd_pedido,
			S.dt_ins [Received Date],
			S.Dt_Ins_Pedido [Order Created Date],
			S.Dt_Ins_JOB			[JOB Created Date],
			S.Num_Proc				[JOB],
			--Informations Pre Defined
			P.Cd_Pes					[Group Code],
			P.Apelido					[Group Name],
			TP.cd_Tp_Pedido				[Type Code],
			TP.Nome_Tp_Pedido			[Type Name],
			TSP.Cd_Tp_Status_Pedido		[Status Code],
			TSP.Nome_Tp_Status_Pedido	[Status Name],
			PA.Cd_Pais					[Origin Code],
			PA.Nome_Pais				[Origin Name]
		from 
			ATL_INT.dbo.JSON_Oxiteno_Salesorder S with(nolock)
			join Pessoa P with(nolock) on P.cd_pes = 'P21128'
			join Tipo_Pedido TP with(nolock) on TP.Cd_tp_Pedido = '3'
			join Tipo_Status_Pedido TSP with(nolock) on TSP.Cd_Tp_Status_Pedido = 'O'
			join Pais PA with(nolock) on PA.Cd_Pais = 'BR'
			--left join Pedido PE with(nolock) on PE.Num_Pedido = S.numero_pedido and  PE.Cd_Grupo = 'P21128'
			--left join Pedido_ship PS with(nolock) on PS.Cd_Pedido = PE.Cd_Pedido
		Where
			S.Dt_Ins_Pedido is null
			and S.[Message] is null
			--and PE.cd_pedido is null
			--and PS.cd_pedido is null
			
			--and S.ID_Salesorder in (940)
			
	End

if @Tipo = 'Y' --Test Leandro 05/08 apagar depois de testar
	Begin
		select 
			S.ID_Salesorder [Internal Code],
			S.numero_pedido,
			S.cnpj,
			S.data_pedido_venda,
			S.cliente_codigo,
			S.cliente_nome,
			S.observacoes,
			S.pedido_cliente,
			S.forma_pagamento,
			S.incoterm,
			S.local_origem,
			S.local_destino,
			S.moeda,
			S.tipo_equipamento,
			S.tipo_carga,
			S.pais_destino,
			S.modal,
			S.valor_total,
			S.seller,
			S.cliente_end,
			S.cliente_cep,
			S.cliente_cidade,
			S.cliente_pais,
			S.qtd_equipamento,
			[dbo].[fBusca_Data_Liberacao_JSON_Oxiteno_Salesorder_Line](S.ID_Salesorder) Dt_Pedido,
			S.[Message] Message,
			S.cd_pedido,
			S.dt_ins [Received Date],
			S.Dt_Ins_Pedido [Order Created Date],
			S.Dt_Ins_JOB			[JOB Created Date],
			S.Num_Proc				[JOB],
			--Informations Pre Defined
			P.Cd_Pes					[Group Code],
			P.Apelido					[Group Name],
			TP.cd_Tp_Pedido				[Type Code],
			TP.Nome_Tp_Pedido			[Type Name],
			TSP.Cd_Tp_Status_Pedido		[Status Code],
			TSP.Nome_Tp_Status_Pedido	[Status Name],
			PA.Cd_Pais					[Origin Code],
			PA.Nome_Pais				[Origin Name]
		from 
			ATL_INT.dbo.JSON_Oxiteno_Salesorder S with(nolock)
			join Pessoa P with(nolock) on P.cd_pes = 'P21128'
			join Tipo_Pedido TP with(nolock) on TP.Cd_tp_Pedido = '3'
			join Tipo_Status_Pedido TSP with(nolock) on TSP.Cd_Tp_Status_Pedido = 'O'
			join Pais PA with(nolock) on PA.Cd_Pais = 'BR'
			--left join Pedido PE with(nolock) on PE.Num_Pedido = S.numero_pedido and  PE.Cd_Grupo = 'P21128'
			--left join Pedido_ship PS with(nolock) on PS.Cd_Pedido = PE.Cd_Pedido
		Where
			--S.Dt_Ins_Pedido is null
			--and S.[Message] is null
			S.ID_Salesorder in (290328)  --290328
			--and PE.cd_pedido is null
			--and PS.cd_pedido is null
			
			--and S.ID_Salesorder in (940)
			
	End
	
if @Tipo = 'X'
	Begin
		select 	distinct 
			S.ID_Salesorder [Internal Code],
			S.numero_pedido,
			NULL cnpj,
			NULL data_pedido_venda,
			NULL cliente_codigo,
			NULL cliente_nome,
			NULL observacoes,
			NULL pedido_cliente,
			NULL forma_pagamento,
			NULL incoterm,
			NULL local_origem,
			NULL local_destino,
			NULL moeda,
			NULL tipo_equipamento,
			NULL tipo_carga,
			NULL pais_destino,
			NULL modal,
			NULL valor_total,
			NULL seller,
			NULL cliente_end,
			NULL cliente_cep,
			NULL cliente_cidade,
			NULL cliente_pais,
			NULL qtd_equipamento,
			NULL Dt_Pedido,
			NULL  Message,
			S.cd_pedido,
			NULL [Received Date],
			NULL [Order Created Date],
			NULL [JOB Created Date],
			S.Num_Proc				[JOB],
			--Informations Pre Defined
			P.Cd_Pes					[Group Code],
			P.Apelido					[Group Name],
			TP.cd_Tp_Pedido				[Type Code],
			TP.Nome_Tp_Pedido			[Type Name],
			TSP.Cd_Tp_Status_Pedido		[Status Code],
			TSP.Nome_Tp_Status_Pedido	[Status Name],
			PA.Cd_Pais					[Origin Code],
			PA.Nome_Pais				[Origin Name]
		from 
			ATL_INT.dbo.JSON_Oxiteno_Salesorder S with(nolock)
			join Pessoa P with(nolock) on P.cd_pes = 'P21128'
			join Tipo_Pedido TP with(nolock) on TP.Cd_tp_Pedido = '3'
			join Tipo_Status_Pedido TSP with(nolock) on TSP.Cd_Tp_Status_Pedido = 'O'
			join Pais PA with(nolock) on PA.Cd_Pais = 'BR'
			join Pedido_Ship PS on PS.NUm_proc = S.Num_Proc and PS.CD_pedido = S.CD_pedido
			left join ATL_INT.dbo.JSON_Oxiteno_jobExport JE on JE.NUm_proc = S.Num_Proc and JE.CD_pedido = S.CD_pedido
		Where
			JE.Dt_Sent is null	
			and S.Num_Proc is not null
		order by
			1
	End

if @Tipo = 'Q'
	Begin
		select distinct
			S.ID_Salesorder [Internal Code],
			S.numero_pedido,
			S.cnpj,
			S.data_pedido_venda,
			S.cliente_codigo,
			S.cliente_nome,
			S.observacoes,
			S.pedido_cliente,
			S.forma_pagamento,
			S.incoterm,
			S.local_origem,
			S.local_destino,
			S.moeda,
			S.tipo_equipamento,
			S.tipo_carga,
			S.pais_destino,
			S.modal,
			S.valor_total,
			S.seller,
			S.cliente_end,
			S.cliente_cep,
			S.cliente_cidade,
			S.cliente_pais,
			S.qtd_equipamento,
			[dbo].[fBusca_Data_Liberacao_JSON_Oxiteno_Salesorder_Line](S.ID_Salesorder) Dt_Pedido,
			S.[Message] Message,
			S.cd_pedido,
			S.dt_ins [Received Date],
			S.Dt_Ins_Pedido [Order Created Date],
			S.Dt_Ins_JOB			[JOB Created Date],
			S.Num_Proc				[JOB],
			--Informations Pre Defined
			P.Cd_Pes					[Group Code],
			P.Apelido					[Group Name],
			TP.cd_Tp_Pedido				[Type Code],
			TP.Nome_Tp_Pedido			[Type Name],
			TSP.Cd_Tp_Status_Pedido		[Status Code],
			TSP.Nome_Tp_Status_Pedido	[Status Name],
			PA.Cd_Pais					[Origin Code],
			PA.Nome_Pais				[Origin Name],
			CP130.Campo_Dados
		from ATL_INT.dbo.JSON_Oxiteno_Salesorder S with(nolock)
			join Pessoa P with(nolock) on P.cd_pes = 'P21128'
			join Tipo_Pedido TP with(nolock) on TP.Cd_tp_Pedido = '3'
			join Tipo_Status_Pedido TSP with(nolock) on TSP.Cd_Tp_Status_Pedido = 'O'
			join Pais PA with(nolock) on PA.Cd_Pais = 'BR'
			join vwHouse_Exp HOU with(nolock) on S.NUm_proc = HOU.Num_Proc					
			--join Exchange EXC with(nolock) on HOU.NUm_proc COLLATE DATABASE_DEFAULT = EXC.ExcProcesso  COLLATE DATABASE_DEFAULT	
			join Pessoa_LLP LLP with(nolock) on LLP.cd_pes = HOU.cd_consig and cd_pes_grupo = 'P21128'
			left join Campo_Processo CP130 with(nolock) on CP130.NUm_proc = HOU.Num_Proc and CP130.ID_Campo = 130
			join Tarefas_Processos TP15 with(nolock) on TP15.NUm_proc = HOU.Num_Proc and TP15.Id_Task = 15
		Where
			--HOU.num_proc not in ('EOOXT202208002BR') and
			--EXC.ExcDataAlt > getdate() -3
			--and 
			CP130.Campo_Dados is not null	
			and TP15.Dt_conclusao is null
	End

if @Tipo = 'I' --usada na tela do Integrated Received
	Begin
		select 
			S.ID_Salesorder [Internal Code],
			S.numero_pedido,
			S.cnpj,
			S.data_pedido_venda,
			S.cliente_codigo,
			S.cliente_nome,
			S.observacoes,
			S.pedido_cliente,
			S.forma_pagamento,
			S.incoterm,
			S.local_origem,
			S.local_destino,
			S.moeda,
			S.tipo_equipamento,
			S.tipo_carga,
			S.pais_destino,
			S.modal,
			S.valor_total,
			S.seller,
			S.cliente_end,
			S.cliente_cep,
			S.cliente_cidade,
			S.cliente_pais,
			S.qtd_equipamento,
			[dbo].[fBusca_Data_Liberacao_JSON_Oxiteno_Salesorder_Line](S.ID_Salesorder) Dt_Pedido,
			S.[Message] Message,
			
			S.cd_pedido,
			S.dt_ins				[Received Date],
			S.Dt_Ins_Pedido			[Order Created Date],
			S.Dt_Ins_JOB			[JOB Created Date],
			S.Num_Proc				[JOB],
			--Informations Pre Defined
			P.Cd_Pes					[Group Code],
			P.Apelido					[Group Name],
			TP.cd_Tp_Pedido				[Type Code],
			TP.Nome_Tp_Pedido			[Type Name],
			TSP.Cd_Tp_Status_Pedido		[Status Code],
			TSP.Nome_Tp_Status_Pedido	[Status Name],
			PA.Cd_Pais					[Origin Code],
			PA.Nome_Pais				[Origin Name]
		from 
			ATL_INT.dbo.JSON_Oxiteno_Salesorder S with(nolock)
			join Pessoa P with(nolock) on P.cd_pes = 'P21128'
			join Tipo_Pedido TP with(nolock) on TP.Cd_tp_Pedido = '3'
			join Tipo_Status_Pedido TSP with(nolock) on TSP.Cd_Tp_Status_Pedido = 'O'
			join Pais PA with(nolock) on PA.Cd_Pais = 'BR'
		Where
			S.dt_ins > getdate() -1			
	End

GO
