SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Retificacao_DI_Sel]
(
	@Num_Proc		varchar(16),
	@Id_Tp_Proc_Adm BigInt,
	@Tipo			char(1)
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

*/

if @Tipo = 'A' 
	Begin
	
--		 1ª JOB
--2ª Client  
--3ª CNPJ
--4ª Admin Process Type
--5ª RFB Dt Protocol
--6ª DI Number
--7ª DI Date
--8ª Em diante 
	
		select 
			R.NUM_PROC							[JOB],
			C.Nome_Raz_Soc						[Client],
			C.Num_CPF_CNPJ						[CNPJ],
			R.Id_Tp_Proc_Adm					[ID Admin Process Type],
			TPA.Nome_Tp_Proc_Adm				[Admin Process Type],
			CONVERT(varchar(10),R.DT_RETIFICACAO,103) [RFB Dt Protocol],
			PO.Numero_DI						[DI Number],
			CONVERT(varchar(10),PO.Data_DI,103)	[DI Date],
			R.CD_DESPACHANTE					[ID Responsible],
			DESP.Nome_Usuario					[Responsible Name],
			R.NR_RETIFICACAO					[Administrative Process Number],			
			CONVERT(varchar(10),R.DT_SOLICITACAO,103) [Register Date],
			R.CD_SOLICITANTE					[ID User],
			SOL.Nome_Usuario					[User Name],
			PO.Numero_PO						[PO Nº],			
			R.ID_TP_RET							[ID Type Adjustment],			
			TR.NOME_TP_RET						[Type Adjustment],
			R.ID_TP_USUARIO_RET					[ID Initiative],
			TU.Nome_TP_Usuario_RET				[Type Initiative],
			R.DE								[From:],
			R.PARA								[To:],
			R.VL_TOTAL_IMPOSTOS					[Amount of Original Taxes],
			R.VL_TOTAL_IMPOSTOS_RECOLHIDOS		[Amount of Compl. Taxes After Rectification],
			R.NOME_TAX_CLIENTE					[Responsible TAX],	
			--NOME_ITO_CLIENTE					[Responsible ITO],
			QTDE_ADICOES_DI						[Total Add to the Declaration],
			QTDE_ADICOES_RETIFICADA				[Amount of rectified add],
			R.ID_STATUS							[ID Status],
			TS.Status_Descricao					[Type Status],
			CONVERT(varchar(10),R.DT_ULTIMA,103)[Date Update],
			Responsavel							[Process Admin Responsible],
			R.ATIVO								[Enabled],
			Notas								[Notes]
		from [Retificacao_DI] R with(nolock)
			left join usuario SOL with(nolock) on SOL.Cd_Usuario = R.CD_SOLICITANTE
			left join usuario DESP with(nolock) on DESP.Cd_Usuario = R.CD_DESPACHANTE
			left join Tipo_RetificacaoDI TR with(nolock) on TR.ID_TP_RET = R.ID_TP_RET
			left join Tipo_Usuario_Retificacao TU with(nolock) on TU.ID_TP_Usuario_RET = R.ID_TP_USUARIO_RET
			left join Tipo_Status_Retificacao TS with(nolock) on TS.ID_Status = R.ID_STATUS
			left join vwCliente_House HOU with(nolock) on HOU.Num_Proc = R.Num_Proc
			left join Pessoa C with(nolock) on C.Cd_Pes= HOU.cd_cliente
			left join vwPO_Imp PO with(nolock) on PO.Num_Proc = R.Num_Proc
			left join Tipo_Processo_Administrativo TPA with(nolock) on TPA.Id_Tp_Proc_Adm  = R.Id_Tp_Proc_Adm 
	End
	
if @Tipo = 'B'
	Begin
		select 
			R.NUM_PROC							[JOB],
			C.Nome_Raz_Soc						[Client],
			C.Num_CPF_CNPJ						[CNPJ],
			R.Id_Tp_Proc_Adm					[ID Admin Process Type],
			TPA.Nome_Tp_Proc_Adm				[Admin Process Type],
			CONVERT(varchar(10),R.DT_RETIFICACAO,103) [RFB Dt Protocol],
			PO.Numero_DI						[DI Number],
			CONVERT(varchar(10),PO.Data_DI,103)	[DI Date],
			R.CD_DESPACHANTE					[ID Responsible],
			DESP.Nome_Usuario					[Responsible Name],
			R.NR_RETIFICACAO					[Administrative Process Number],			
			CONVERT(varchar(10),R.DT_SOLICITACAO,103) [Register Date],
			R.CD_SOLICITANTE					[ID User],
			SOL.Nome_Usuario					[User Name],
			PO.Numero_PO						[PO Nº],			
			R.ID_TP_RET							[ID Type Adjustment],			
			TR.NOME_TP_RET						[Type Adjustment],
			R.ID_TP_USUARIO_RET					[ID Initiative],
			TU.Nome_TP_Usuario_RET				[Type Initiative],
			R.DE								[From:],
			R.PARA								[To:],
			R.VL_TOTAL_IMPOSTOS					[Amount of Original Taxes],
			R.VL_TOTAL_IMPOSTOS_RECOLHIDOS		[Amount of Compl. Taxes After Rectification],
			R.NOME_TAX_CLIENTE					[Responsible TAX],	
			--NOME_ITO_CLIENTE					[Responsible ITO],
			QTDE_ADICOES_DI						[Total Add to the Declaration],
			QTDE_ADICOES_RETIFICADA				[Amount of rectified add],
			R.ID_STATUS							[ID Status],
			TS.Status_Descricao					[Type Status],
			CONVERT(varchar(10),R.DT_ULTIMA,103)[Date Update],
			Responsavel							[Process Admin Responsible],
			R.ATIVO								[Enabled],
			Notas								[Notes]
		from [Retificacao_DI] R with(nolock)
			left join usuario SOL with(nolock) on SOL.Cd_Usuario = R.CD_SOLICITANTE
			left join usuario DESP with(nolock) on DESP.Cd_Usuario = R.CD_DESPACHANTE
			left join Tipo_RetificacaoDI TR with(nolock) on TR.ID_TP_RET = R.ID_TP_RET
			left join Tipo_Usuario_Retificacao TU with(nolock) on TU.ID_TP_Usuario_RET = R.ID_TP_USUARIO_RET
			left join Tipo_Status_Retificacao TS with(nolock) on TS.ID_Status = R.ID_STATUS
			left join vwCliente_House HOU with(nolock) on HOU.Num_Proc = R.Num_Proc
			left join Pessoa C with(nolock) on C.Cd_Pes= HOU.cd_cliente
			left join vwPO_Imp PO with(nolock) on PO.Num_Proc = R.Num_Proc
			left join Tipo_Processo_Administrativo TPA with(nolock) on TPA.Id_Tp_Proc_Adm  = R.Id_Tp_Proc_Adm 
		where
			R.ATIVO = 1
			--and DT_SOLICITACAO > GETDATE() - 90
	End
	
if @Tipo = 'C' 
	Begin
		select 
			R.NUM_PROC							[JOB],
			C.Nome_Raz_Soc						[Client],
			C.Num_CPF_CNPJ						[CNPJ],
			R.Id_Tp_Proc_Adm					[ID Admin Process Type],
			TPA.Nome_Tp_Proc_Adm				[Admin Process Type],
			CONVERT(varchar(10),R.DT_RETIFICACAO,103) [RFB Dt Protocol],
			PO.Numero_DI						[DI Number],
			CONVERT(varchar(10),PO.Data_DI,103)	[DI Date],
			R.CD_DESPACHANTE					[ID Responsible],
			DESP.Nome_Usuario					[Responsible Name],
			R.NR_RETIFICACAO					[Administrative Process Number],			
			CONVERT(varchar(10),R.DT_SOLICITACAO,103) [Register Date],
			R.CD_SOLICITANTE					[ID User],
			SOL.Nome_Usuario					[User Name],
			PO.Numero_PO						[PO Nº],			
			R.ID_TP_RET							[ID Type Adjustment],			
			TR.NOME_TP_RET						[Type Adjustment],
			R.ID_TP_USUARIO_RET					[ID Initiative],
			TU.Nome_TP_Usuario_RET				[Type Initiative],
			R.DE								[From:],
			R.PARA								[To:],
			R.VL_TOTAL_IMPOSTOS					[Amount of Original Taxes],
			R.VL_TOTAL_IMPOSTOS_RECOLHIDOS		[Amount of Compl. Taxes After Rectification],
			R.NOME_TAX_CLIENTE					[Responsible TAX],	
			--NOME_ITO_CLIENTE					[Responsible ITO],
			QTDE_ADICOES_DI						[Total Add to the Declaration],
			QTDE_ADICOES_RETIFICADA				[Amount of rectified add],
			R.ID_STATUS							[ID Status],
			TS.Status_Descricao					[Type Status],
			CONVERT(varchar(10),R.DT_ULTIMA,103)[Date Update],
			Responsavel							[Process Admin Responsible],
			R.ATIVO								[Enabled],
			Notas								[Notes]
		from [Retificacao_DI] R with(nolock)
			left join usuario SOL with(nolock) on SOL.Cd_Usuario = R.CD_SOLICITANTE
			left join usuario DESP with(nolock) on DESP.Cd_Usuario = R.CD_DESPACHANTE
			left join Tipo_RetificacaoDI TR with(nolock) on TR.ID_TP_RET = R.ID_TP_RET
			left join Tipo_Usuario_Retificacao TU with(nolock) on TU.ID_TP_Usuario_RET = R.ID_TP_USUARIO_RET
			left join Tipo_Status_Retificacao TS with(nolock) on TS.ID_Status = R.ID_STATUS
			left join vwCliente_House HOU with(nolock) on HOU.Num_Proc = R.Num_Proc
			left join Pessoa C with(nolock) on C.Cd_Pes= HOU.cd_cliente
			left join vwPO_Imp PO with(nolock) on PO.Num_Proc = R.Num_Proc
			left join Tipo_Processo_Administrativo TPA with(nolock) on TPA.Id_Tp_Proc_Adm  = R.Id_Tp_Proc_Adm 
		where
			R.NUM_PROC = @Num_Proc
	End
	
if @Tipo = 'D'
	Begin
		select 
			R.NUM_PROC							[JOB],
			C.Nome_Raz_Soc						[Client],
			C.Num_CPF_CNPJ						[CNPJ],
			R.Id_Tp_Proc_Adm					[ID Admin Process Type],
			TPA.Nome_Tp_Proc_Adm				[Admin Process Type],
			CONVERT(varchar(10),R.DT_RETIFICACAO,103) [RFB Dt Protocol],
			PO.Numero_DI						[DI Number],
			CONVERT(varchar(10),PO.Data_DI,103)	[DI Date],
			R.CD_DESPACHANTE					[ID Responsible],
			DESP.Nome_Usuario					[Responsible Name],
			R.NR_RETIFICACAO					[Administrative Process Number],			
			CONVERT(varchar(10),R.DT_SOLICITACAO,103) [Register Date],
			R.CD_SOLICITANTE					[ID User],
			SOL.Nome_Usuario					[User Name],
			PO.Numero_PO						[PO Nº],			
			R.ID_TP_RET							[ID Type Adjustment],			
			TR.NOME_TP_RET						[Type Adjustment],
			R.ID_TP_USUARIO_RET					[ID Initiative],
			TU.Nome_TP_Usuario_RET				[Type Initiative],
			R.DE								[From:],
			R.PARA								[To:],
			R.VL_TOTAL_IMPOSTOS					[Amount of Original Taxes],
			R.VL_TOTAL_IMPOSTOS_RECOLHIDOS		[Amount of Compl. Taxes After Rectification],
			R.NOME_TAX_CLIENTE					[Responsible TAX],	
			--NOME_ITO_CLIENTE					[Responsible ITO],
			QTDE_ADICOES_DI						[Total Add to the Declaration],
			QTDE_ADICOES_RETIFICADA				[Amount of rectified add],
			R.ID_STATUS							[ID Status],
			TS.Status_Descricao					[Type Status],
			CONVERT(varchar(10),R.DT_ULTIMA,103)[Date Update],
			Responsavel							[Process Admin Responsible],
			R.ATIVO								[Enabled],
			Notas								[Notes]
		from [Retificacao_DI] R with(nolock)
			left join usuario SOL with(nolock) on SOL.Cd_Usuario = R.CD_SOLICITANTE
			left join usuario DESP with(nolock) on DESP.Cd_Usuario = R.CD_DESPACHANTE
			left join Tipo_RetificacaoDI TR with(nolock) on TR.ID_TP_RET = R.ID_TP_RET
			left join Tipo_Usuario_Retificacao TU with(nolock) on TU.ID_TP_Usuario_RET = R.ID_TP_USUARIO_RET
			left join Tipo_Status_Retificacao TS with(nolock) on TS.ID_Status = R.ID_STATUS
			left join vwCliente_House HOU with(nolock) on HOU.Num_Proc = R.Num_Proc
			left join Pessoa C with(nolock) on C.Cd_Pes= HOU.cd_cliente
			left join vwPO_Imp PO with(nolock) on PO.Num_Proc = R.Num_Proc
			left join Tipo_Processo_Administrativo TPA with(nolock) on TPA.Id_Tp_Proc_Adm  = R.Id_Tp_Proc_Adm 
		where
			R.NUM_PROC = @Num_Proc and R.ATIVO = 1			
	End
	
if @Tipo = 'N' 
	Begin
		select 
			R.NUM_PROC							[JOB],
			C.Nome_Raz_Soc						[Client],
			C.Num_CPF_CNPJ						[CNPJ],
			R.Id_Tp_Proc_Adm					[ID Admin Process Type],
			TPA.Nome_Tp_Proc_Adm				[Admin Process Type],
			CONVERT(varchar(10),R.DT_RETIFICACAO,103) [RFB Dt Protocol],
			PO.Numero_DI						[DI Number],
			CONVERT(varchar(10),PO.Data_DI,103)	[DI Date],
			R.CD_DESPACHANTE					[ID Responsible],
			DESP.Nome_Usuario					[Responsible Name],
			R.NR_RETIFICACAO					[Administrative Process Number],			
			CONVERT(varchar(10),R.DT_SOLICITACAO,103) [Register Date],
			R.CD_SOLICITANTE					[ID User],
			SOL.Nome_Usuario					[User Name],
			PO.Numero_PO						[PO Nº],			
			R.ID_TP_RET							[ID Type Adjustment],			
			TR.NOME_TP_RET						[Type Adjustment],
			R.ID_TP_USUARIO_RET					[ID Initiative],
			TU.Nome_TP_Usuario_RET				[Type Initiative],
			R.DE								[From:],
			R.PARA								[To:],
			R.VL_TOTAL_IMPOSTOS					[Amount of Original Taxes],
			R.VL_TOTAL_IMPOSTOS_RECOLHIDOS		[Amount of Compl. Taxes After Rectification],
			R.NOME_TAX_CLIENTE					[Responsible TAX],	
			--NOME_ITO_CLIENTE					[Responsible ITO],
			QTDE_ADICOES_DI						[Total Add to the Declaration],
			QTDE_ADICOES_RETIFICADA				[Amount of rectified add],
			R.ID_STATUS							[ID Status],
			TS.Status_Descricao					[Type Status],
			CONVERT(varchar(10),R.DT_ULTIMA,103)[Date Update],
			Responsavel							[Process Admin Responsible],
			R.ATIVO								[Enabled],
			Notas								[Notes]
		from [Retificacao_DI] R with(nolock)
			left join usuario SOL with(nolock) on SOL.Cd_Usuario = R.CD_SOLICITANTE
			left join usuario DESP with(nolock) on DESP.Cd_Usuario = R.CD_DESPACHANTE
			left join Tipo_RetificacaoDI TR with(nolock) on TR.ID_TP_RET = R.ID_TP_RET
			left join Tipo_Usuario_Retificacao TU with(nolock) on TU.ID_TP_Usuario_RET = R.ID_TP_USUARIO_RET
			left join Tipo_Status_Retificacao TS with(nolock) on TS.ID_Status = R.ID_STATUS
			left join vwCliente_House HOU with(nolock) on HOU.Num_Proc = R.Num_Proc
			left join Pessoa C with(nolock) on C.Cd_Pes= HOU.cd_cliente
			left join vwPO_Imp PO with(nolock) on PO.Num_Proc = R.Num_Proc
			left join Tipo_Processo_Administrativo TPA with(nolock) on TPA.Id_Tp_Proc_Adm  = R.Id_Tp_Proc_Adm 
		where
			R.NUM_PROC = @Num_Proc and R.Id_Tp_Proc_Adm = @Id_Tp_Proc_Adm	
			
	End
	
if  @Tipo = 'O'
	Begin
		select 
			R.NUM_PROC							[JOB],
			C.Nome_Raz_Soc						[Client],
			C.Num_CPF_CNPJ						[CNPJ],
			R.Id_Tp_Proc_Adm					[ID Admin Process Type],
			TPA.Nome_Tp_Proc_Adm				[Admin Process Type],
			CONVERT(varchar(10),R.DT_RETIFICACAO,103) [RFB Dt Protocol],
			PO.Numero_DI						[DI Number],
			CONVERT(varchar(10),PO.Data_DI,103)	[DI Date],
			R.CD_DESPACHANTE					[ID Responsible],
			DESP.Nome_Usuario					[Responsible Name],
			R.NR_RETIFICACAO					[Administrative Process Number],			
			CONVERT(varchar(10),R.DT_SOLICITACAO,103) [Register Date],
			R.CD_SOLICITANTE					[ID User],
			SOL.Nome_Usuario					[User Name],
			PO.Numero_PO						[PO Nº],			
			R.ID_TP_RET							[ID Type Adjustment],			
			TR.NOME_TP_RET						[Type Adjustment],
			R.ID_TP_USUARIO_RET					[ID Initiative],
			TU.Nome_TP_Usuario_RET				[Type Initiative],
			R.DE								[From:],
			R.PARA								[To:],
			R.VL_TOTAL_IMPOSTOS					[Amount of Original Taxes],
			R.VL_TOTAL_IMPOSTOS_RECOLHIDOS		[Amount of Compl. Taxes After Rectification],
			R.NOME_TAX_CLIENTE					[Responsible TAX],	
			--NOME_ITO_CLIENTE					[Responsible ITO],
			QTDE_ADICOES_DI						[Total Add to the Declaration],
			QTDE_ADICOES_RETIFICADA				[Amount of rectified add],
			R.ID_STATUS							[ID Status],
			TS.Status_Descricao					[Type Status],
			CONVERT(varchar(10),R.DT_ULTIMA,103)[Date Update],
			Responsavel							[Process Admin Responsible],
			R.ATIVO								[Enabled],
			Notas								[Notes]
		from [Retificacao_DI] R with(nolock)
			left join usuario SOL with(nolock) on SOL.Cd_Usuario = R.CD_SOLICITANTE
			left join usuario DESP with(nolock) on DESP.Cd_Usuario = R.CD_DESPACHANTE
			left join Tipo_RetificacaoDI TR with(nolock) on TR.ID_TP_RET = R.ID_TP_RET
			left join Tipo_Usuario_Retificacao TU with(nolock) on TU.ID_TP_Usuario_RET = R.ID_TP_USUARIO_RET
			left join Tipo_Status_Retificacao TS with(nolock) on TS.ID_Status = R.ID_STATUS
			left join vwCliente_House HOU with(nolock) on HOU.Num_Proc = R.Num_Proc
			left join Pessoa C with(nolock) on C.Cd_Pes= HOU.cd_cliente
			left join vwPO_Imp PO with(nolock) on PO.Num_Proc = R.Num_Proc
			left join Tipo_Processo_Administrativo TPA with(nolock) on TPA.Id_Tp_Proc_Adm  = R.Id_Tp_Proc_Adm 
		where
			R.NUM_PROC = @Num_Proc and R.Id_Tp_Proc_Adm = @Id_Tp_Proc_Adm	
			and R.ATIVO = 1			
	End

--SP_HELP Retificacao_DI
/*
ALTER procedure [dbo].[spATL_Retificacao_DI_Sel]
(
	@Num_Proc		varchar(16),
	@Id_Tp_Proc_Adm BigInt,
	@Tipo			char(1)
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

*/

if @Tipo = 'A' 
	Begin
	
--		 1ª JOB
--2ª Client  
--3ª CNPJ
--4ª Admin Process Type
--5ª RFB Dt Protocol
--6ª DI Number
--7ª DI Date
--8ª Em diante 
	
		select 
			R.NUM_PROC							[JOB],
			C.Nome_Raz_Soc						[Client],
			C.Num_CPF_CNPJ						[CNPJ],
			R.Id_Tp_Proc_Adm					[ID Admin Process Type],
			TPA.Nome_Tp_Proc_Adm				[Admin Process Type],
			CONVERT(varchar(10),R.DT_RETIFICACAO,103) [RFB Dt Protocol],
			PO.Numero_DI						[DI Number],
			CONVERT(varchar(10),PO.Data_DI,103)	[DI Date],
			R.CD_DESPACHANTE					[ID Responsible],
			DESP.Nome_Usuario					[Responsible Name],
			R.NR_RETIFICACAO					[Administrative Process Number],			
			CONVERT(varchar(10),R.DT_SOLICITACAO,103) [Register Date],
			R.CD_SOLICITANTE					[ID User],
			SOL.Nome_Usuario					[User Name],
			PO.Numero_PO						[PO Nº],			
			R.ID_TP_RET							[ID Type Adjustment],			
			TR.NOME_TP_RET						[Type Adjustment],
			R.ID_TP_USUARIO_RET					[ID Initiative],
			TU.Nome_TP_Usuario_RET				[Type Initiative],
			R.DE								[From:],
			R.PARA								[To:],
			R.VL_TOTAL_IMPOSTOS					[Amount of Original Taxes],
			R.VL_TOTAL_IMPOSTOS_RECOLHIDOS		[Amount of Compl. Taxes After Rectification],
			R.NOME_TAX_CLIENTE					[Responsible TAX],	
			--NOME_ITO_CLIENTE					[Responsible ITO],
			QTDE_ADICOES_DI						[Total Add to the Declaration],
			QTDE_ADICOES_RETIFICADA				[Amount of rectified add],
			R.ID_STATUS							[ID Status],
			TS.Status_Descricao					[Type Status],
			CONVERT(varchar(10),R.DT_ULTIMA,103)[Date Update],
			Responsavel							[Process Admin Responsible],
			R.ATIVO								[Enabled]			
		from [Retificacao_DI] R with(nolock)
			left join usuario SOL with(nolock) on SOL.Cd_Usuario = R.CD_SOLICITANTE
			left join usuario DESP with(nolock) on DESP.Cd_Usuario = R.CD_DESPACHANTE
			left join Tipo_RetificacaoDI TR with(nolock) on TR.ID_TP_RET = R.ID_TP_RET
			left join Tipo_Usuario_Retificacao TU with(nolock) on TU.ID_TP_Usuario_RET = R.ID_TP_USUARIO_RET
			left join Tipo_Status_Retificacao TS with(nolock) on TS.ID_Status = R.ID_STATUS
			left join vwCliente_House HOU with(nolock) on HOU.Num_Proc = R.Num_Proc
			left join Pessoa C with(nolock) on C.Cd_Pes= HOU.cd_cliente
			left join vwPO_Imp PO with(nolock) on PO.Num_Proc = R.Num_Proc
			left join Tipo_Processo_Administrativo TPA with(nolock) on TPA.Id_Tp_Proc_Adm  = R.Id_Tp_Proc_Adm 
	End
	
if @Tipo = 'B'
	Begin
		select 
			R.NUM_PROC							[JOB],
			C.Nome_Raz_Soc						[Client],
			C.Num_CPF_CNPJ						[CNPJ],
			R.Id_Tp_Proc_Adm					[ID Admin Process Type],
			TPA.Nome_Tp_Proc_Adm				[Admin Process Type],
			CONVERT(varchar(10),R.DT_RETIFICACAO,103) [RFB Dt Protocol],
			PO.Numero_DI						[DI Number],
			CONVERT(varchar(10),PO.Data_DI,103)	[DI Date],
			R.CD_DESPACHANTE					[ID Responsible],
			DESP.Nome_Usuario					[Responsible Name],
			R.NR_RETIFICACAO					[Administrative Process Number],			
			CONVERT(varchar(10),R.DT_SOLICITACAO,103) [Register Date],
			R.CD_SOLICITANTE					[ID User],
			SOL.Nome_Usuario					[User Name],
			PO.Numero_PO						[PO Nº],			
			R.ID_TP_RET							[ID Type Adjustment],			
			TR.NOME_TP_RET						[Type Adjustment],
			R.ID_TP_USUARIO_RET					[ID Initiative],
			TU.Nome_TP_Usuario_RET				[Type Initiative],
			R.DE								[From:],
			R.PARA								[To:],
			R.VL_TOTAL_IMPOSTOS					[Amount of Original Taxes],
			R.VL_TOTAL_IMPOSTOS_RECOLHIDOS		[Amount of Compl. Taxes After Rectification],
			R.NOME_TAX_CLIENTE					[Responsible TAX],	
			--NOME_ITO_CLIENTE					[Responsible ITO],
			QTDE_ADICOES_DI						[Total Add to the Declaration],
			QTDE_ADICOES_RETIFICADA				[Amount of rectified add],
			R.ID_STATUS							[ID Status],
			TS.Status_Descricao					[Type Status],
			CONVERT(varchar(10),R.DT_ULTIMA,103)[Date Update],
			Responsavel							[Process Admin Responsible],
			R.ATIVO								[Enabled]	
		from [Retificacao_DI] R with(nolock)
			left join usuario SOL with(nolock) on SOL.Cd_Usuario = R.CD_SOLICITANTE
			left join usuario DESP with(nolock) on DESP.Cd_Usuario = R.CD_DESPACHANTE
			left join Tipo_RetificacaoDI TR with(nolock) on TR.ID_TP_RET = R.ID_TP_RET
			left join Tipo_Usuario_Retificacao TU with(nolock) on TU.ID_TP_Usuario_RET = R.ID_TP_USUARIO_RET
			left join Tipo_Status_Retificacao TS with(nolock) on TS.ID_Status = R.ID_STATUS
			left join vwCliente_House HOU with(nolock) on HOU.Num_Proc = R.Num_Proc
			left join Pessoa C with(nolock) on C.Cd_Pes= HOU.cd_cliente
			left join vwPO_Imp PO with(nolock) on PO.Num_Proc = R.Num_Proc
			left join Tipo_Processo_Administrativo TPA with(nolock) on TPA.Id_Tp_Proc_Adm  = R.Id_Tp_Proc_Adm 
		where
			R.ATIVO = 1
			--and DT_SOLICITACAO > GETDATE() - 90
	End
	
if @Tipo = 'C' 
	Begin
		select 
			R.NUM_PROC							[JOB],
			C.Nome_Raz_Soc						[Client],
			C.Num_CPF_CNPJ						[CNPJ],
			R.Id_Tp_Proc_Adm					[ID Admin Process Type],
			TPA.Nome_Tp_Proc_Adm				[Admin Process Type],
			CONVERT(varchar(10),R.DT_RETIFICACAO,103) [RFB Dt Protocol],
			PO.Numero_DI						[DI Number],
			CONVERT(varchar(10),PO.Data_DI,103)	[DI Date],
			R.CD_DESPACHANTE					[ID Responsible],
			DESP.Nome_Usuario					[Responsible Name],
			R.NR_RETIFICACAO					[Administrative Process Number],			
			CONVERT(varchar(10),R.DT_SOLICITACAO,103) [Register Date],
			R.CD_SOLICITANTE					[ID User],
			SOL.Nome_Usuario					[User Name],
			PO.Numero_PO						[PO Nº],			
			R.ID_TP_RET							[ID Type Adjustment],			
			TR.NOME_TP_RET						[Type Adjustment],
			R.ID_TP_USUARIO_RET					[ID Initiative],
			TU.Nome_TP_Usuario_RET				[Type Initiative],
			R.DE								[From:],
			R.PARA								[To:],
			R.VL_TOTAL_IMPOSTOS					[Amount of Original Taxes],
			R.VL_TOTAL_IMPOSTOS_RECOLHIDOS		[Amount of Compl. Taxes After Rectification],
			R.NOME_TAX_CLIENTE					[Responsible TAX],	
			--NOME_ITO_CLIENTE					[Responsible ITO],
			QTDE_ADICOES_DI						[Total Add to the Declaration],
			QTDE_ADICOES_RETIFICADA				[Amount of rectified add],
			R.ID_STATUS							[ID Status],
			TS.Status_Descricao					[Type Status],
			CONVERT(varchar(10),R.DT_ULTIMA,103)[Date Update],
			Responsavel							[Process Admin Responsible],
			R.ATIVO								[Enabled]
		from [Retificacao_DI] R with(nolock)
			left join usuario SOL with(nolock) on SOL.Cd_Usuario = R.CD_SOLICITANTE
			left join usuario DESP with(nolock) on DESP.Cd_Usuario = R.CD_DESPACHANTE
			left join Tipo_RetificacaoDI TR with(nolock) on TR.ID_TP_RET = R.ID_TP_RET
			left join Tipo_Usuario_Retificacao TU with(nolock) on TU.ID_TP_Usuario_RET = R.ID_TP_USUARIO_RET
			left join Tipo_Status_Retificacao TS with(nolock) on TS.ID_Status = R.ID_STATUS
			left join vwCliente_House HOU with(nolock) on HOU.Num_Proc = R.Num_Proc
			left join Pessoa C with(nolock) on C.Cd_Pes= HOU.cd_cliente
			left join vwPO_Imp PO with(nolock) on PO.Num_Proc = R.Num_Proc
			left join Tipo_Processo_Administrativo TPA with(nolock) on TPA.Id_Tp_Proc_Adm  = R.Id_Tp_Proc_Adm 
		where
			R.NUM_PROC = @Num_Proc
	End
	
if @Tipo = 'D'
	Begin
		select 
			R.NUM_PROC							[JOB],
			C.Nome_Raz_Soc						[Client],
			C.Num_CPF_CNPJ						[CNPJ],
			R.Id_Tp_Proc_Adm					[ID Admin Process Type],
			TPA.Nome_Tp_Proc_Adm				[Admin Process Type],
			CONVERT(varchar(10),R.DT_RETIFICACAO,103) [RFB Dt Protocol],
			PO.Numero_DI						[DI Number],
			CONVERT(varchar(10),PO.Data_DI,103)	[DI Date],
			R.CD_DESPACHANTE					[ID Responsible],
			DESP.Nome_Usuario					[Responsible Name],
			R.NR_RETIFICACAO					[Administrative Process Number],			
			CONVERT(varchar(10),R.DT_SOLICITACAO,103) [Register Date],
			R.CD_SOLICITANTE					[ID User],
			SOL.Nome_Usuario					[User Name],
			PO.Numero_PO						[PO Nº],			
			R.ID_TP_RET							[ID Type Adjustment],			
			TR.NOME_TP_RET						[Type Adjustment],
			R.ID_TP_USUARIO_RET					[ID Initiative],
			TU.Nome_TP_Usuario_RET				[Type Initiative],
			R.DE								[From:],
			R.PARA								[To:],
			R.VL_TOTAL_IMPOSTOS					[Amount of Original Taxes],
			R.VL_TOTAL_IMPOSTOS_RECOLHIDOS		[Amount of Compl. Taxes After Rectification],
			R.NOME_TAX_CLIENTE					[Responsible TAX],	
			--NOME_ITO_CLIENTE					[Responsible ITO],
			QTDE_ADICOES_DI						[Total Add to the Declaration],
			QTDE_ADICOES_RETIFICADA				[Amount of rectified add],
			R.ID_STATUS							[ID Status],
			TS.Status_Descricao					[Type Status],
			CONVERT(varchar(10),R.DT_ULTIMA,103)[Date Update],
			Responsavel							[Process Admin Responsible],
			R.ATIVO								[Enabled]
		from [Retificacao_DI] R with(nolock)
			left join usuario SOL with(nolock) on SOL.Cd_Usuario = R.CD_SOLICITANTE
			left join usuario DESP with(nolock) on DESP.Cd_Usuario = R.CD_DESPACHANTE
			left join Tipo_RetificacaoDI TR with(nolock) on TR.ID_TP_RET = R.ID_TP_RET
			left join Tipo_Usuario_Retificacao TU with(nolock) on TU.ID_TP_Usuario_RET = R.ID_TP_USUARIO_RET
			left join Tipo_Status_Retificacao TS with(nolock) on TS.ID_Status = R.ID_STATUS
			left join vwCliente_House HOU with(nolock) on HOU.Num_Proc = R.Num_Proc
			left join Pessoa C with(nolock) on C.Cd_Pes= HOU.cd_cliente
			left join vwPO_Imp PO with(nolock) on PO.Num_Proc = R.Num_Proc
			left join Tipo_Processo_Administrativo TPA with(nolock) on TPA.Id_Tp_Proc_Adm  = R.Id_Tp_Proc_Adm 
		where
			R.NUM_PROC = @Num_Proc and R.ATIVO = 1			
	End
	
if @Tipo = 'N' 
	Begin
		select 
			R.NUM_PROC							[JOB],
			C.Nome_Raz_Soc						[Client],
			C.Num_CPF_CNPJ						[CNPJ],
			R.Id_Tp_Proc_Adm					[ID Admin Process Type],
			TPA.Nome_Tp_Proc_Adm				[Admin Process Type],
			CONVERT(varchar(10),R.DT_RETIFICACAO,103) [RFB Dt Protocol],
			PO.Numero_DI						[DI Number],
			CONVERT(varchar(10),PO.Data_DI,103)	[DI Date],
			R.CD_DESPACHANTE					[ID Responsible],
			DESP.Nome_Usuario					[Responsible Name],
			R.NR_RETIFICACAO					[Administrative Process Number],			
			CONVERT(varchar(10),R.DT_SOLICITACAO,103) [Register Date],
			R.CD_SOLICITANTE					[ID User],
			SOL.Nome_Usuario					[User Name],
			PO.Numero_PO						[PO Nº],			
			R.ID_TP_RET							[ID Type Adjustment],			
			TR.NOME_TP_RET						[Type Adjustment],
			R.ID_TP_USUARIO_RET					[ID Initiative],
			TU.Nome_TP_Usuario_RET				[Type Initiative],
			R.DE								[From:],
			R.PARA								[To:],
			R.VL_TOTAL_IMPOSTOS					[Amount of Original Taxes],
			R.VL_TOTAL_IMPOSTOS_RECOLHIDOS		[Amount of Compl. Taxes After Rectification],
			R.NOME_TAX_CLIENTE					[Responsible TAX],	
			--NOME_ITO_CLIENTE					[Responsible ITO],
			QTDE_ADICOES_DI						[Total Add to the Declaration],
			QTDE_ADICOES_RETIFICADA				[Amount of rectified add],
			R.ID_STATUS							[ID Status],
			TS.Status_Descricao					[Type Status],
			CONVERT(varchar(10),R.DT_ULTIMA,103)[Date Update],
			Responsavel							[Process Admin Responsible],
			R.ATIVO								[Enabled]
		from [Retificacao_DI] R with(nolock)
			left join usuario SOL with(nolock) on SOL.Cd_Usuario = R.CD_SOLICITANTE
			left join usuario DESP with(nolock) on DESP.Cd_Usuario = R.CD_DESPACHANTE
			left join Tipo_RetificacaoDI TR with(nolock) on TR.ID_TP_RET = R.ID_TP_RET
			left join Tipo_Usuario_Retificacao TU with(nolock) on TU.ID_TP_Usuario_RET = R.ID_TP_USUARIO_RET
			left join Tipo_Status_Retificacao TS with(nolock) on TS.ID_Status = R.ID_STATUS
			left join vwCliente_House HOU with(nolock) on HOU.Num_Proc = R.Num_Proc
			left join Pessoa C with(nolock) on C.Cd_Pes= HOU.cd_cliente
			left join vwPO_Imp PO with(nolock) on PO.Num_Proc = R.Num_Proc
			left join Tipo_Processo_Administrativo TPA with(nolock) on TPA.Id_Tp_Proc_Adm  = R.Id_Tp_Proc_Adm 
		where
			R.NUM_PROC = @Num_Proc and R.Id_Tp_Proc_Adm = @Id_Tp_Proc_Adm	
			
	End
	
if  @Tipo = 'O'
	Begin
		select 
			R.NUM_PROC							[JOB],
			C.Nome_Raz_Soc						[Client],
			C.Num_CPF_CNPJ						[CNPJ],
			R.Id_Tp_Proc_Adm					[ID Admin Process Type],
			TPA.Nome_Tp_Proc_Adm				[Admin Process Type],
			CONVERT(varchar(10),R.DT_RETIFICACAO,103) [RFB Dt Protocol],
			PO.Numero_DI						[DI Number],
			CONVERT(varchar(10),PO.Data_DI,103)	[DI Date],
			R.CD_DESPACHANTE					[ID Responsible],
			DESP.Nome_Usuario					[Responsible Name],
			R.NR_RETIFICACAO					[Administrative Process Number],			
			CONVERT(varchar(10),R.DT_SOLICITACAO,103) [Register Date],
			R.CD_SOLICITANTE					[ID User],
			SOL.Nome_Usuario					[User Name],
			PO.Numero_PO						[PO Nº],			
			R.ID_TP_RET							[ID Type Adjustment],			
			TR.NOME_TP_RET						[Type Adjustment],
			R.ID_TP_USUARIO_RET					[ID Initiative],
			TU.Nome_TP_Usuario_RET				[Type Initiative],
			R.DE								[From:],
			R.PARA								[To:],
			R.VL_TOTAL_IMPOSTOS					[Amount of Original Taxes],
			R.VL_TOTAL_IMPOSTOS_RECOLHIDOS		[Amount of Compl. Taxes After Rectification],
			R.NOME_TAX_CLIENTE					[Responsible TAX],	
			--NOME_ITO_CLIENTE					[Responsible ITO],
			QTDE_ADICOES_DI						[Total Add to the Declaration],
			QTDE_ADICOES_RETIFICADA				[Amount of rectified add],
			R.ID_STATUS							[ID Status],
			TS.Status_Descricao					[Type Status],
			CONVERT(varchar(10),R.DT_ULTIMA,103)[Date Update],
			Responsavel							[Process Admin Responsible],
			R.ATIVO								[Enabled]
		from [Retificacao_DI] R with(nolock)
			left join usuario SOL with(nolock) on SOL.Cd_Usuario = R.CD_SOLICITANTE
			left join usuario DESP with(nolock) on DESP.Cd_Usuario = R.CD_DESPACHANTE
			left join Tipo_RetificacaoDI TR with(nolock) on TR.ID_TP_RET = R.ID_TP_RET
			left join Tipo_Usuario_Retificacao TU with(nolock) on TU.ID_TP_Usuario_RET = R.ID_TP_USUARIO_RET
			left join Tipo_Status_Retificacao TS with(nolock) on TS.ID_Status = R.ID_STATUS
			left join vwCliente_House HOU with(nolock) on HOU.Num_Proc = R.Num_Proc
			left join Pessoa C with(nolock) on C.Cd_Pes= HOU.cd_cliente
			left join vwPO_Imp PO with(nolock) on PO.Num_Proc = R.Num_Proc
			left join Tipo_Processo_Administrativo TPA with(nolock) on TPA.Id_Tp_Proc_Adm  = R.Id_Tp_Proc_Adm 
		where
			R.NUM_PROC = @Num_Proc and R.Id_Tp_Proc_Adm = @Id_Tp_Proc_Adm	
			and R.ATIVO = 1			
	End
	
*/
	


	
GO
