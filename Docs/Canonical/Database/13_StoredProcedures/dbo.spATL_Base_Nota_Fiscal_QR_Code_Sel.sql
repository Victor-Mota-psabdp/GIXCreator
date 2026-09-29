SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATL_Base_Nota_Fiscal_QR_Code_Sel '','','I','X'
--sp_help Base_Nota_Fiscal_QR_Code
--spATL_Base_Nota_Fiscal_QR_Code_Sel '','','K','X'
CREATE procedure [dbo].[spATL_Base_Nota_Fiscal_QR_Code_Sel]
(	
	@ID				int,
	@Nota_Fiscal	varchar(30),
	@Ref_Acesso		varchar(30),
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
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		Select 
			QR.Id				[Code],				
			BNF.Ref_Acesso		[Invoice Type Code],
			SI.Nome_Site		[Invoice Type Name],
			BNF.Nota_Fiscal		[RPS Number],
			
			BNF.RPS_NFE			[NFS-e Number],
			BNF.RPS_NFE_Verif	[Verification Code],
			BNF.RPS_Data		[Register Date],
						
			QR.Imagem			[Image],
			QR.QRcode_Url		[QRcode_Url],
			
			QR.Dt_Ins			[Insert Date],
			QR.Cd_Usuario		[User Code],
			US.nome_usuario		[User Name],
			QR.Status			[Enabled],
			QR.Used				[Used],
			
			
			P.Apelido			[Client Name],
			P.Nome_Raz_Soc		[Client Complete Name]

			,P.Num_CPF_CNPJ		[Num_CPF_CNPJ],

			(Case when (P.Cd_Tp_Ativ = 'AGT' and len(P.Num_CPF_CNPJ) = 0) then '256' else	
				(Case when (FAT.Item_lei = '33.01') then '147' else	
					(Case when (left(FAT.Item_lei,2) = '10') then '255'
					else null
					 end) end) end) [ID_DC],	
			P.Cd_Tp_Ativ, 
			FAT.Item_lei
			,SI.CNPJ_BDP
			,'http://visualizar.ginfes.com.br/report/consultarNota?__report=nfs_ver4&cdVerificacao=' + BNF.RPS_NFE_Verif + '&numNota=' + BNF.RPS_NFE + '&cnpjPrestador='+ SI.CNPJ_BDP URLImagem
		from Base_Nota_Fiscal BNF  	with(nolock)
			join Fatura_arg FAT with(nolock) on BNF.Nota_Fiscal  = FAT.Numero and BNF.Ref_Acesso = FAT.Codigo 
			join SITE SI 	with(nolock) on SI.Cd_Site = BNF.Ref_Acesso
			left join Base_Nota_Fiscal_QR_Code QR 	with(nolock) on BNF.Nota_Fiscal = QR.Nota_Fiscal and BNF.Ref_Acesso = QR.Ref_Acesso
			left join Usuario US 	with(nolock) on US.cd_usuario = QR.cd_usuario
			left join Pessoa P 	with(nolock) on P.Cd_Pes = BNF.Cd_Pes
		where 
			QR.Id = @ID	
			and bnf.Cd_Status <> '2'		
		order by
			BNF.RPS_Data
			
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		Select 
			QR.Id				[Code],				
			BNF.Ref_Acesso		[Invoice Type Code],
			SI.Nome_Site		[Invoice Type Name],
			BNF.Nota_Fiscal		[RPS Number],
			
			BNF.RPS_NFE			[NFS-e Number],
			BNF.RPS_NFE_Verif	[Verification Code],
			BNF.RPS_Data		[Register Date],
						
			QR.Imagem			[Image],
			QR.QRcode_Url		[QRcode_Url],
			
			QR.Dt_Ins			[Insert Date],
			QR.Cd_Usuario		[User Code],
			US.nome_usuario		[User Name],
			QR.Status			[Enabled],
			QR.Used			[Used],
			
			P.Apelido			[Client Name],
			P.Nome_Raz_Soc		[Client Complete Name]
			
			
			,P.Num_CPF_CNPJ		[Num_CPF_CNPJ],

			(Case when (P.Cd_Tp_Ativ = 'AGT' and len(P.Num_CPF_CNPJ) = 0) then '256' else	
				(Case when (FAT.Item_lei = '33.01') then '147' else	
					(Case when (left(FAT.Item_lei,2) = '10') then '255'
					else null
					 end) end) end) [ID_DC],	
			P.Cd_Tp_Ativ, 
			FAT.Item_lei
			,SI.CNPJ_BDP
			,'http://visualizar.ginfes.com.br/report/consultarNota?__report=nfs_ver4&cdVerificacao=' + BNF.RPS_NFE_Verif + '&numNota=' + BNF.RPS_NFE + '&cnpjPrestador='+ SI.CNPJ_BDP URLImagem
		from Base_Nota_Fiscal BNF  	with(nolock)
			join Fatura_arg FAT with(nolock) on BNF.Nota_Fiscal  = FAT.Numero and BNF.Ref_Acesso = FAT.Codigo 
			join SITE SI 	with(nolock) on SI.Cd_Site = BNF.Ref_Acesso
			left join Base_Nota_Fiscal_QR_Code QR 	with(nolock) on BNF.Nota_Fiscal = QR.Nota_Fiscal and BNF.Ref_Acesso = QR.Ref_Acesso
			left join Usuario US 	with(nolock) on US.cd_usuario = QR.cd_usuario
			left join Pessoa P 	with(nolock) on P.Cd_Pes = BNF.Cd_Pes
		where 
			BNF.Ref_Acesso = @Ref_Acesso and BNF.Emissao > GETDATE() - 120
			and BNF.RPS_NFE_Verif is not null
			and isnull(QR.Used ,0) = 0
			and bnf.Cd_Status <> '2'
		order by
			BNF.RPS_Data
	End	
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		Select 
			QR.Id				[Code],				
			BNF.Ref_Acesso		[Invoice Type Code],
			SI.Nome_Site		[Invoice Type Name],
			BNF.Nota_Fiscal		[RPS Number],
			
			BNF.RPS_NFE			[NFS-e Number],
			BNF.RPS_NFE_Verif	[Verification Code],
			BNF.RPS_Data		[Register Date],
						
			QR.Imagem			[Image],
			QR.QRcode_Url		[QRcode_Url],
			
			QR.Dt_Ins			[Insert Date],
			QR.Cd_Usuario		[User Code],
			US.nome_usuario		[User Name],
			QR.Status			[Enabled],
			QR.Used			[Used],
			
			
			P.Apelido			[Client Name],
			P.Nome_Raz_Soc		[Client Complete Name]


			,P.Num_CPF_CNPJ		[Num_CPF_CNPJ],

			(Case when (P.Cd_Tp_Ativ = 'AGT' and len(P.Num_CPF_CNPJ) = 0) then '256' else	
				(Case when (FAT.Item_lei = '33.01') then '147' else	
					(Case when (left(FAT.Item_lei,2) = '10') then '255'
					else null
					 end) end) end) [ID_DC],	
			P.Cd_Tp_Ativ, 
			FAT.Item_lei
			,SI.CNPJ_BDP
			,'http://visualizar.ginfes.com.br/report/consultarNota?__report=nfs_ver4&cdVerificacao=' + BNF.RPS_NFE_Verif + '&numNota=' + BNF.RPS_NFE + '&cnpjPrestador='+ SI.CNPJ_BDP URLImagem
		from Base_Nota_Fiscal BNF  	with(nolock)
			join Fatura_arg FAT with(nolock) on BNF.Nota_Fiscal  = FAT.Numero and BNF.Ref_Acesso = FAT.Codigo 
			join SITE SI 	with(nolock) on SI.Cd_Site = BNF.Ref_Acesso
			left join Base_Nota_Fiscal_QR_Code QR 	with(nolock) on BNF.Nota_Fiscal = QR.Nota_Fiscal and BNF.Ref_Acesso = QR.Ref_Acesso
			left join Usuario US 	with(nolock) on US.cd_usuario = QR.cd_usuario
			left join Pessoa P 	with(nolock) on P.Cd_Pes = BNF.Cd_Pes
		where 
			BNF.Nota_Fiscal = @Nota_Fiscal and BNF.Ref_Acesso = @Ref_Acesso
			and bnf.Cd_Status <> '2'
		order by
			BNF.RPS_Data
	End
	
if @Tipo = 'X' 
	Begin
		Select distinct
			QR.Id				[Code],				
			BNF.Ref_Acesso		[Invoice Type Code],
			SI.Nome_Site		[Invoice Type Name],
			BNF.Nota_Fiscal		[RPS Number],
			
			BNF.RPS_NFE			[NFS-e Number],
			BNF.RPS_NFE_Verif	[Verification Code],
			BNF.RPS_Data		[Register Date],
						
			--QR.Imagem			[Image],
			NULL			[Image],
			QR.QRcode_Url		[QRcode_Url],
			
			QR.Dt_Ins			[Insert Date],
			QR.Cd_Usuario		[User Code],
			US.nome_usuario		[User Name],
			QR.Status			[Enabled],
			QR.Used			[Used],
			
			
			P.Apelido			[Client Name],
			P.Nome_Raz_Soc		[Client Complete Name],
			P.Num_CPF_CNPJ		[Num_CPF_CNPJ],

			(Case when (P.Cd_Tp_Ativ = 'AGT' and len(P.Num_CPF_CNPJ) = 0) then '256' else	
				(Case when (FAT.Item_lei = '33.01') then '147' else	
					(Case when (left(FAT.Item_lei,2) = '10') then '255'
					else null
					 end) end) end) [ID_DC],	
			P.Cd_Tp_Ativ, 
			FAT.Item_lei
			,SI.CNPJ_BDP

			--'3548500'							[CodigoMunicipio],
			--,Case when @Ref_Acesso = 'I' then 
			--	'https://gissv2-3548500.eiconbrasil.com.br/service-declaracao/api/nota-autenticacao/3548500/download/' + BNF.RPS_ID +'/codigo-verificacao/' + BNF.RPS_NFE_Verif
			--else
			--	'http://visualizar.ginfes.com.br/report/consultarNota?__report=nfs_ver4&cdVerificacao=' + BNF.RPS_NFE_Verif + '&numNota=' + BNF.RPS_NFE + '&cnpjPrestador='+ SI.CNPJ_BDP
			--	END URLImagem
			,Case when @Ref_Acesso = 'I' then 
			--,Case when BNF.Ref_Acesso = 'I' then
				'https://3548500.giss.com.br/service-relatorio/api/relatorio/nota-autenticacao/pdf/3548500/' + BNF.RPS_ID +'/codigo-verificacao/' + BNF.RPS_NFE_Verif --adicionado Leandro 27/04
				--'https://gissv2-3548500.eiconbrasil.com.br/service-declaracao/api/nota-autenticacao/3548500/download/' + BNF.RPS_ID +'/codigo-verificacao/' + BNF.RPS_NFE_Verif
			else
				'https://3548807.giss.com.br/service-relatorio/api/relatorio/nota-autenticacao/pdf/3548807/' + BNF.RPS_ID +'/codigo-verificacao/' + BNF.RPS_NFE_Verif --adicionado Leandro 27/04 
				END URLImagem
		from Base_Nota_Fiscal BNF  	with(nolock)
			join Fatura_arg FAT with(nolock) on BNF.Nota_Fiscal  = FAT.Numero and BNF.Ref_Acesso = FAT.Codigo 
			join SITE SI 	with(nolock) on SI.Cd_Site = BNF.Ref_Acesso
			left join Base_Nota_Fiscal_QR_Code QR 	with(nolock) on BNF.Nota_Fiscal = QR.Nota_Fiscal and BNF.Ref_Acesso = QR.Ref_Acesso
			left join Usuario US 	with(nolock) on US.cd_usuario = QR.cd_usuario
			join Pessoa P 	with(nolock) on P.Cd_Pes = BNF.Cd_Pes
			join endereco E with(nolock) on E.cd_pes = BNF.cd_pes and E.cd_tp_end = 'COM'
			--left join vwFaturasValidasArg FAT 	with(nolock) on BNF.Nota_Fiscal  = FAT.Numero and BNF.Ref_Acesso = FAT.Ref_Accesso_Arg
			--left join Doc_Anexos DOC 	with(nolock) on DOC.Num_Proc = FAT.Num_Proc and DOC.Id_DC = '147'
		where 
			--BNF.Ref_Acesso = @Ref_Acesso 
			--and BNF.Emissao > getdate() -1
			----and DOC.Item_Doc is null
			--and BNF.RPS_NFE_Verif is not null
			

			
			BNF.Ref_Acesso = @Ref_Acesso
			and BNF.Emissao > GETDATE() -20
			and BNF.RPS_NFE_Verif is not null
			and isnull(QR.Used ,0) = 0
			and bnf.Cd_Status <> '2'
		order by
			BNF.RPS_Data
	End


	if @Tipo = 'T' --TEST CASE 20/02/2026 LEANDRO
	Begin
		Select distinct
			QR.Id				[Code],				
			BNF.Ref_Acesso		[Invoice Type Code],
			SI.Nome_Site		[Invoice Type Name],
			BNF.Nota_Fiscal		[RPS Number],
			
			BNF.RPS_NFE			[NFS-e Number],
			BNF.RPS_NFE_Verif	[Verification Code],
			BNF.RPS_Data		[Register Date],
						
			--QR.Imagem			[Image],
			NULL			[Image],
			QR.QRcode_Url		[QRcode_Url],
			
			QR.Dt_Ins			[Insert Date],
			QR.Cd_Usuario		[User Code],
			US.nome_usuario		[User Name],
			QR.Status			[Enabled],
			QR.Used			[Used],
			
			
			P.Apelido			[Client Name],
			P.Nome_Raz_Soc		[Client Complete Name],
			P.Num_CPF_CNPJ		[Num_CPF_CNPJ],

			(Case when (P.Cd_Tp_Ativ = 'AGT' and len(P.Num_CPF_CNPJ) = 0) then '256' else	
				(Case when (FAT.Item_lei = '33.01') then '147' else	
					(Case when (left(FAT.Item_lei,2) = '10') then '255'
					else null
					 end) end) end) [ID_DC],	
			P.Cd_Tp_Ativ, 
			FAT.Item_lei
			,SI.CNPJ_BDP

			--'3548500'							[CodigoMunicipio],
			,Case when @Ref_Acesso = 'I' then 
				'https://3548500.giss.com.br/service-relatorio/api/relatorio/nota-autenticacao/pdf/3548500/' + BNF.RPS_ID +'/codigo-verificacao/' + BNF.RPS_NFE_Verif --adicionado Leandro 27/04
				--'https://gissv2-3548500.eiconbrasil.com.br/service-declaracao/api/nota-autenticacao/3548500/download/' + BNF.RPS_ID +'/codigo-verificacao/' + BNF.RPS_NFE_Verif
			else
				'https://3548807.giss.com.br/service-relatorio/api/relatorio/nota-autenticacao/pdf/3548807/' + BNF.RPS_ID +'/codigo-verificacao/' + BNF.RPS_NFE_Verif --adicionado Leandro 27/04
				--'http://visualizar.ginfes.com.br/report/consultarNota?__report=nfs_ver4&cdVerificacao=' + BNF.RPS_NFE_Verif + '&numNota=' + BNF.RPS_NFE + '&cnpjPrestador='+ SI.CNPJ_BDP
				END URLImagem
		from Base_Nota_Fiscal BNF  	with(nolock)
			join Fatura_arg FAT with(nolock) on BNF.Nota_Fiscal  = FAT.Numero and BNF.Ref_Acesso = FAT.Codigo 
			join SITE SI 	with(nolock) on SI.Cd_Site = BNF.Ref_Acesso
			left join Base_Nota_Fiscal_QR_Code QR 	with(nolock) on BNF.Nota_Fiscal = QR.Nota_Fiscal and BNF.Ref_Acesso = QR.Ref_Acesso
			left join Usuario US 	with(nolock) on US.cd_usuario = QR.cd_usuario
			join Pessoa P 	with(nolock) on P.Cd_Pes = BNF.Cd_Pes
			join endereco E with(nolock) on E.cd_pes = BNF.cd_pes and E.cd_tp_end = 'COM'
			--left join vwFaturasValidasArg FAT 	with(nolock) on BNF.Nota_Fiscal  = FAT.Numero and BNF.Ref_Acesso = FAT.Ref_Accesso_Arg
			--left join Doc_Anexos DOC 	with(nolock) on DOC.Num_Proc = FAT.Num_Proc and DOC.Id_DC = '147'
		where 
			--BNF.Ref_Acesso = @Ref_Acesso 
			--and BNF.Emissao > getdate() -1
			----and DOC.Item_Doc is null
			--and BNF.RPS_NFE_Verif is not null
			BNF.Nota_Fiscal = 181600 
			and BNF.Ref_Acesso = 'I' 
			--and BNF.Emissao > GETDATE() -10
			--and BNF.RPS_NFE_Verif is not null
			--and isnull(QR.Used ,0) = 0
			--and bnf.Cd_Status <> '2'
		order by
			BNF.RPS_Data
	End


GO
