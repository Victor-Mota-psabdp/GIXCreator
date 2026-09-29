SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spArquivosSyncro_Sel 'IOCSR201202021BR','7039', '000489'

CREATE Procedure [dbo].[spArquivosSyncro_Sel] --'IMCSR201103011BR','',''

@JOB	varchar(16),
@IDNF	int,
@NF		varchar(30)

	as 
		if @IDNF = '' and @NF = ''
			begin
				select distinct nc.id_nf,nc.num_proc,nc.nota_fiscal, nc.vlr_nf, PES.apelido,
				nc.emissao,nc.envio,nc.data_envio,nc.mensagem_erro
				from nota_cliente NC with(nolock)
				join nota_fiscal_cliente_det NF with(nolock) on nf.id_nf=nc.id_nf and nf.cd_cliente=nc.cd_cliente
				left join Pessoa PES with(nolock) on PES.Cd_pes = NF.Cd_Cliente
				where num_proc = @JOB
			end

		else if @NF = ''
			begin
				select distinct nc.id_nf,nc.num_proc,nc.nota_fiscal, nc.vlr_nf, PES.apelido,
				nc.emissao,nc.envio,nc.data_envio,nc.mensagem_erro
				from nota_cliente NC with(nolock)
				join nota_fiscal_cliente_det NF with(nolock) on nf.id_nf=nc.id_nf and nf.cd_cliente=nc.cd_cliente
				left join Pessoa PES with(nolock) on PES.Cd_pes = NF.Cd_Cliente
				where num_proc = @JOB and nc.ID_NF = @IDNF
			end

		else if @IDNF = '' 
				begin
					select distinct nc.id_nf,nc.num_proc,nc.nota_fiscal, nc.vlr_nf, PES.apelido,
					nc.emissao,nc.envio,nc.data_envio,nc.mensagem_erro
					from nota_cliente NC with(nolock)
					join nota_fiscal_cliente_det NF with(nolock)	on nf.id_nf=nc.id_nf and nf.cd_cliente=nc.cd_cliente
					left join Pessoa PES with(nolock)	on PES.Cd_pes = NF.Cd_Cliente
					where num_proc = @JOB 
					and right('0000000000' + nc.nota_Fiscal,10) = right('0000000000' + @NF,10)
				end
		else 
				begin
					select distinct nc.id_nf,nc.num_proc,nc.nota_fiscal, nc.vlr_nf, PES.apelido,
					nc.emissao,nc.envio,nc.data_envio,nc.mensagem_erro
					from nota_cliente NC with(nolock)
					join nota_fiscal_cliente_det NF with(nolock)	on nf.id_nf=nc.id_nf and nf.cd_cliente=nc.cd_cliente
					left join Pessoa PES with(nolock)	on PES.Cd_pes = NF.Cd_Cliente
					where num_proc = @JOB  
					and right('0000000000' + nc.nota_Fiscal,10) = right('0000000000' + @NF,10) 
					and nc.ID_NF = @IDNF
				end















GO
