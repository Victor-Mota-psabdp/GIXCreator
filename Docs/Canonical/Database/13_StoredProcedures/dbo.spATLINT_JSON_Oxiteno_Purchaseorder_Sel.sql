SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATLINT_JSON_Oxiteno_Purchaseorder_Sel Null, NULL,'P'
CREATE PROCEDURE [dbo].[spATLINT_JSON_Oxiteno_Purchaseorder_Sel]
(
	@ID_Purchaseorder	bigint,
	@nr_oc				int,
	@Tipo				char(1)
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
sp_help JSON_Oxiteno_Purchaseorder
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 
			S.ID_Purchaseorder [Internal Code],
			S.nr_oc,
			S.data_oc,
			S.incoterm,
			S.moeda,
			S.status,
			S.exportador,
			S.modal,
			S.valor_total,
			S.pais_origem,
			S.pais_destino,
			S.cia,
			S.filial,
			S.nome_comprador,
			S.exportador_cod,
			S.exportador_end_cod,
			S.empresa_cod,
			S.empresa_cnpj,
			S.exportador_endereco,
			S.exportador_end_cidade,
			S.exportador_end_cep,
			--S.exportador_end_pais,
			(case when S.exportador_end_pais = 'USA' then 'United States' else S.exportador_end_pais end) exportador_end_pais,
			--[dbo].[fBusca_Data_JSON_Oxiteno_Purchaseorder_Line](S.ID_Purchaseorder,'data_requisicao') Dt_Pedido,
			S.data_oc  Dt_Pedido,
			[dbo].[fBusca_Data_JSON_Oxiteno_Purchaseorder_Line](S.ID_Purchaseorder,'data_promessa') DL_Chegada,
			S.[Message] Message,
			S.cd_pedido,

			S.dt_ins			[Received Date],
			S.Dt_Ins_Pedido		[Order Created Date],

			S.Dt_Ins_JOB		[JOB Created Date],
			S.Num_Proc			[JOB],
			S.termo_pagamento,
			S.local_origem,
			S.local_destino,
			isnull(S.tipo_carga,'FCL') tipo_carga,
			S.area_compradora,
			--Informations Pre Defined
			P.Cd_Pes					[Group Code],
			P.Apelido					[Group Name],
			TP.cd_Tp_Pedido				[Type Code],
			TP.Nome_Tp_Pedido			[Type Name],
			TSP.Cd_Tp_Status_Pedido		[Status Code],
			TSP.Nome_Tp_Status_Pedido	[Status Name]		
		from 
			ATL_INT.dbo.JSON_Oxiteno_Purchaseorder S with(nolock)
			join Pessoa P with(nolock) on P.cd_pes = 'P21128'
			join Tipo_Pedido TP with(nolock) on TP.Cd_tp_Pedido = '2'
			join Tipo_Status_Pedido TSP with(nolock) on TSP.Cd_Tp_Status_Pedido = 'O'
		where
			S.data_oc > '2022-01-01'
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			S.ID_Purchaseorder [Internal Code],
			S.nr_oc,
			S.data_oc,
			S.incoterm,
			S.moeda,
			S.status,
			S.exportador,
			S.modal,
			S.valor_total,
			S.pais_origem,
			S.pais_destino,
			S.cia,
			S.filial,
			S.nome_comprador,
			S.exportador_cod,
			S.exportador_end_cod,
			S.empresa_cod,
			S.empresa_cnpj,
			S.exportador_endereco,
			S.exportador_end_cidade,
			S.exportador_end_cep,
			(case when S.exportador_end_pais = 'USA' then 'United States' else S.exportador_end_pais end) exportador_end_pais,
			--[dbo].[fBusca_Data_JSON_Oxiteno_Purchaseorder_Line](S.ID_Purchaseorder,'data_requisicao') Dt_Pedido,
			S.data_oc  Dt_Pedido,
			[dbo].[fBusca_Data_JSON_Oxiteno_Purchaseorder_Line](S.ID_Purchaseorder,'data_promessa') DL_Chegada,
			S.[Message] Message,
			S.cd_pedido,

			S.dt_ins [Received Date],
			S.Dt_Ins_Pedido [Order Created Date],

			S.Dt_Ins_JOB		[JOB Created Date],
			S.Num_Proc			[JOB],
			S.termo_pagamento,
			S.local_origem,
			S.local_destino,
			isnull(S.tipo_carga,'FCL') tipo_carga,
			S.area_compradora,
			--Informations Pre Defined
			P.Cd_Pes					[Group Code],
			P.Apelido					[Group Name],
			TP.cd_Tp_Pedido				[Type Code],
			TP.Nome_Tp_Pedido			[Type Name],
			TSP.Cd_Tp_Status_Pedido		[Status Code],
			TSP.Nome_Tp_Status_Pedido	[Status Name]		
		from 
			ATL_INT.dbo.JSON_Oxiteno_Purchaseorder S with(nolock)
			join Pessoa P with(nolock) on P.cd_pes = 'P21128'
			join Tipo_Pedido TP with(nolock) on TP.Cd_tp_Pedido = '2'
			join Tipo_Status_Pedido TSP with(nolock) on TSP.Cd_Tp_Status_Pedido = 'O'
		where 
			ID_Purchaseorder = @ID_Purchaseorder
			
	End

if @Tipo = 'N' 
	Begin
		select 
			S.ID_Purchaseorder [Internal Code],
			S.nr_oc,
			S.data_oc,
			S.incoterm,
			S.moeda,
			S.status,
			S.exportador,
			S.modal,
			S.valor_total,
			S.pais_origem,
			S.pais_destino,
			S.cia,
			S.filial,
			S.nome_comprador,
			S.exportador_cod,
			S.exportador_end_cod,
			S.empresa_cod,
			S.empresa_cnpj,
			S.exportador_endereco,
			S.exportador_end_cidade,
			S.exportador_end_cep,
			(case when S.exportador_end_pais = 'USA' then 'United States' else S.exportador_end_pais end) exportador_end_pais,
			--[dbo].[fBusca_Data_JSON_Oxiteno_Purchaseorder_Line](S.ID_Purchaseorder,'data_requisicao') Dt_Pedido,
			S.data_oc  Dt_Pedido,
			[dbo].[fBusca_Data_JSON_Oxiteno_Purchaseorder_Line](S.ID_Purchaseorder,'data_promessa') DL_Chegada,
			S.[Message] Message,
			S.cd_pedido,

			S.dt_ins [Received Date],
			S.Dt_Ins_Pedido [Order Created Date],

			S.Dt_Ins_JOB		[JOB Created Date],
			S.Num_Proc			[JOB],
			S.termo_pagamento,
			S.local_origem,
			S.local_destino,
			isnull(S.tipo_carga,'FCL') tipo_carga,
			S.area_compradora,
			--Informations Pre Defined
			P.Cd_Pes					[Group Code],
			P.Apelido					[Group Name],
			TP.cd_Tp_Pedido				[Type Code],
			TP.Nome_Tp_Pedido			[Type Name],
			TSP.Cd_Tp_Status_Pedido		[Status Code],
			TSP.Nome_Tp_Status_Pedido	[Status Name]		
		from 
			ATL_INT.dbo.JSON_Oxiteno_Purchaseorder S with(nolock)
			join Pessoa P with(nolock) on P.cd_pes = 'P21128'
			join Tipo_Pedido TP with(nolock) on TP.Cd_tp_Pedido = '2'
			join Tipo_Status_Pedido TSP with(nolock) on TSP.Cd_Tp_Status_Pedido = 'O'		
		where 
			nr_oc = @nr_oc
	End

if @Tipo = 'O'
	Begin
		select 
			S.ID_Purchaseorder [Internal Code],
			S.nr_oc,
			S.data_oc,
			S.incoterm,
			S.moeda,
			S.status,
			S.exportador,
			S.modal,
			S.valor_total,
			S.pais_origem,
			S.pais_destino,
			S.cia,
			S.filial,
			S.nome_comprador,
			S.exportador_cod,
			S.exportador_end_cod,
			S.empresa_cod,
			S.empresa_cnpj,
			S.exportador_endereco,
			S.exportador_end_cidade,
			S.exportador_end_cep,
			(case when S.exportador_end_pais = 'USA' then 'United States' else S.exportador_end_pais end) exportador_end_pais,
			--[dbo].[fBusca_Data_JSON_Oxiteno_Purchaseorder_Line](S.ID_Purchaseorder,'data_requisicao') Dt_Pedido,
			S.data_oc  Dt_Pedido,
			[dbo].[fBusca_Data_JSON_Oxiteno_Purchaseorder_Line](S.ID_Purchaseorder,'data_promessa') DL_Chegada,
			S.[Message] Message,
			S.cd_pedido,

			S.dt_ins [Received Date],
			S.Dt_Ins_Pedido [Order Created Date],

			S.Dt_Ins_JOB		[JOB Created Date],
			S.Num_Proc			[JOB],
			S.termo_pagamento,
			S.local_origem,
			S.local_destino,
			isnull(S.tipo_carga,'FCL') tipo_carga,
			S.area_compradora,
			--Informations Pre Defined
			P.Cd_Pes					[Group Code],
			P.Apelido					[Group Name],
			TP.cd_Tp_Pedido				[Type Code],
			TP.Nome_Tp_Pedido			[Type Name],
			TSP.Cd_Tp_Status_Pedido		[Status Code],
			TSP.Nome_Tp_Status_Pedido	[Status Name]		
		from 
			ATL_INT.dbo.JSON_Oxiteno_Purchaseorder S with(nolock)
			join Pessoa P with(nolock) on P.cd_pes = 'P21128'
			join Tipo_Pedido TP with(nolock) on TP.Cd_tp_Pedido = '2'
			join Tipo_Status_Pedido TSP with(nolock) on TSP.Cd_Tp_Status_Pedido = 'O'		
		where 
			nr_oc = @nr_oc and S.Num_Proc is not null
	End

if @Tipo = 'P'
	Begin
		select 
			S.ID_Purchaseorder [Internal Code],
			S.nr_oc,
			S.data_oc,
			S.incoterm,
			S.moeda,
			S.status,
			S.exportador,
			S.modal,
			S.valor_total,
			S.pais_origem,
			S.pais_destino,
			S.cia,
			S.filial,
			S.nome_comprador,
			S.exportador_cod,
			S.exportador_end_cod,
			S.empresa_cod,
			S.empresa_cnpj,
			S.exportador_endereco,
			S.exportador_end_cidade,
			S.exportador_end_cep,
			(case when S.exportador_end_pais = 'USA' then 'United States' else S.exportador_end_pais end) exportador_end_pais,
			--[dbo].[fBusca_Data_JSON_Oxiteno_Purchaseorder_Line](S.ID_Purchaseorder,'data_requisicao') Dt_Pedido,
			S.data_oc  Dt_Pedido,
			[dbo].[fBusca_Data_JSON_Oxiteno_Purchaseorder_Line](S.ID_Purchaseorder,'data_promessa') DL_Chegada,
			S.[Message] Message,
			S.cd_pedido,

			S.dt_ins [Received Date],
			S.Dt_Ins_Pedido [Order Created Date],

			S.Dt_Ins_JOB		[JOB Created Date],
			S.Num_Proc			[JOB],
			S.termo_pagamento,
			S.local_origem,
			S.local_destino,
			isnull(S.tipo_carga,'FCL') tipo_carga,
			S.area_compradora,
			--Informations Pre Defined
			P.Cd_Pes					[Group Code],
			P.Apelido					[Group Name],
			TP.cd_Tp_Pedido				[Type Code],
			TP.Nome_Tp_Pedido			[Type Name],
			TSP.Cd_Tp_Status_Pedido		[Status Code],
			TSP.Nome_Tp_Status_Pedido	[Status Name]		
		from 
			ATL_INT.dbo.JSON_Oxiteno_Purchaseorder S with(nolock)
			join Pessoa P with(nolock) on P.cd_pes = 'P21128'
			join Tipo_Pedido TP with(nolock) on TP.Cd_tp_Pedido = '2'
			join Tipo_Status_Pedido TSP with(nolock) on TSP.Cd_Tp_Status_Pedido = 'O'		
		where 
			S.Dt_Ins_Pedido is null
			and S.data_oc > '2022-01-01'

		Order by 
			S.ID_Purchaseorder
	End
	

if @Tipo = 'I'--usada na tela do Integrated Received
	Begin
		select 
			S.ID_Purchaseorder [Internal Code],
			S.nr_oc,
			S.data_oc,
			S.incoterm,
			S.moeda,
			S.status,
			S.exportador,
			S.modal,
			S.valor_total,
			S.pais_origem,
			S.pais_destino,
			S.cia,
			S.filial,
			S.nome_comprador,
			S.exportador_cod,
			S.exportador_end_cod,
			S.empresa_cod,
			S.empresa_cnpj,
			S.exportador_endereco,
			S.exportador_end_cidade,
			S.exportador_end_cep,
			--S.exportador_end_pais,
			(case when S.exportador_end_pais = 'USA' then 'United States' else S.exportador_end_pais end) exportador_end_pais,
			--[dbo].[fBusca_Data_JSON_Oxiteno_Purchaseorder_Line](S.ID_Purchaseorder,'data_requisicao') Dt_Pedido,
			S.data_oc  Dt_Pedido,
			[dbo].[fBusca_Data_JSON_Oxiteno_Purchaseorder_Line](S.ID_Purchaseorder,'data_promessa') DL_Chegada,
			S.[Message] Message,
			S.cd_pedido,

			S.dt_ins			[Received Date],
			S.Dt_Ins_Pedido		[Order Created Date],

			S.Dt_Ins_JOB		[JOB Created Date],
			S.Num_Proc			[JOB],
			S.termo_pagamento,
			S.local_origem,
			S.local_destino,
			isnull(S.tipo_carga,'FCL') tipo_carga,
			S.area_compradora,
			--Informations Pre Defined
			P.Cd_Pes					[Group Code],
			P.Apelido					[Group Name],
			TP.cd_Tp_Pedido				[Type Code],
			TP.Nome_Tp_Pedido			[Type Name],
			TSP.Cd_Tp_Status_Pedido		[Status Code],
			TSP.Nome_Tp_Status_Pedido	[Status Name]		
		from 
			ATL_INT.dbo.JSON_Oxiteno_Purchaseorder S with(nolock)
			join Pessoa P with(nolock) on P.cd_pes = 'P21128'
			join Tipo_Pedido TP with(nolock) on TP.Cd_tp_Pedido = '2'
			join Tipo_Status_Pedido TSP with(nolock) on TSP.Cd_Tp_Status_Pedido = 'O'
		where
			S.dt_ins > getdate() -1
	End


	

GO
