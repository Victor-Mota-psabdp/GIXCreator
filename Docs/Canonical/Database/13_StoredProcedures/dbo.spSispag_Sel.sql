SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spSispag_Sel '','00013001',''
--select * from sispag

--spSispag_Sel '32499-2','','S'

CREATE Procedure [dbo].[spSispag_Sel]--'32499-2','','S'

	@num_cta_cte varchar(7),
	@lote		varchar(8),
	@itau		varchar(1)
as

if  @lote = '' and @itau = 'S'

	BEGIN
		select 
			num_lcto LA,
			dt_pgto_rcto Data,
			P.nome_raz_soc	Cliente,
			TB.campo_dados Banco,
			TCB.campo_dados CodigoBanco,
			TCA.campo_dados CodigoAgencia,
			TCC.campo_dados ContaCorrente,
			PR.vlr_doc	Valor
		from pgto_rcto PR 
			join Pessoa P on P.cd_pes = PR.cd_pes
			left join campo_pessoa TB on TB.cd_pes = PR.cd_pes and TB.id_campo = 3
			left join campo_pessoa TCB on TCB.cd_pes = PR.cd_pes and TCB.id_campo = 4
			left join campo_pessoa TCA on TCA.cd_pes = PR.cd_pes and TCA.id_campo = 5
			left join campo_pessoa TCC on TCC.cd_pes = PR.cd_pes and TCC.id_campo = 7			
		where num_cta_cte = @num_cta_cte 
		and concil = 'N' 
		and (tcb.campo_dados = '341' or tcb.campo_dados = '409')
		and forma_pgto_rcto like 'Dep%' 
		and sispag is null

	UNION ALL

		select 
			num_lcto_div LA,
			dt_pgto_rcto_div Data,
			P.nome_raz_soc	Cliente,
			TB.campo_dados Banco,
			TCB.campo_dados CodigoBanco,
			TCA.campo_dados CodigoAgencia,
			TCC.campo_dados ContaCorrente,
			PR.vlr_doc_div	Valor
		from pgto_rcto_div PR 
			join Pessoa P on P.cd_pes = PR.cd_pes
			left join campo_pessoa TB on TB.cd_pes = PR.cd_pes and TB.id_campo = 3
			left join campo_pessoa TCB on TCB.cd_pes = PR.cd_pes and TCB.id_campo = 4
			left join campo_pessoa TCA on TCA.cd_pes = PR.cd_pes and TCA.id_campo = 5
			left join campo_pessoa TCC on TCC.cd_pes = PR.cd_pes and TCC.id_campo = 7
		where num_cta_cte = @num_cta_cte 
		and concil_div = 'N' 
		and (tcb.campo_dados = '341' or tcb.campo_dados = '409')
		and forma_pgto_rcto_div like 'Dep%'
		and sispag is null
	END
else
	BEGIN
		select 
			num_lcto LA,
			dt_pgto_rcto Data,
			P.nome_raz_soc	Cliente,
			TB.campo_dados Banco,
			TCB.campo_dados CodigoBanco,
			TCA.campo_dados CodigoAgencia,
			TCC.campo_dados ContaCorrente,
			PR.vlr_doc	Valor,
			concil	Concil,
			conta,
			STP.tipo_pagamento tipo,
			SFP.forma_pagamento forma		
		from pgto_rcto PR 
			join Pessoa P on P.cd_pes = PR.cd_pes
			left join campo_pessoa TB on TB.cd_pes = PR.cd_pes and TB.id_campo = 3
			left join campo_pessoa TCB on TCB.cd_pes = PR.cd_pes and TCB.id_campo = 4
			left join campo_pessoa TCA on TCA.cd_pes = PR.cd_pes and TCA.id_campo = 5
			left join campo_pessoa TCC on TCC.cd_pes = PR.cd_pes and TCC.id_campo = 7
			left join sispag S on S.lote = PR.sispag
			left join sispag_tipo_pagamento STP on Stp.cd_tipo = S.tipopagamento
			left join sispag_forma_pagamento SFP on SFp.cd_forma = S.formapagamento
		where sispag = @lote

	UNION ALL

		select 
			num_lcto_div LA,
			dt_pgto_rcto_div Data,
			P.nome_raz_soc	Cliente,
			TB.campo_dados Banco,
			TCB.campo_dados CodigoBanco,
			TCA.campo_dados CodigoAgencia,
			TCC.campo_dados ContaCorrente,
			PR.vlr_doc_div	Valor,
			concil_div Concil,
			conta,
			STP.tipo_pagamento tipo,
			SFP.forma_pagamento forma
		from pgto_rcto_div PR 
			join Pessoa P on P.cd_pes = PR.cd_pes
			left join campo_pessoa TB on TB.cd_pes = PR.cd_pes and TB.id_campo = 3
			left join campo_pessoa TCB on TCB.cd_pes = PR.cd_pes and TCB.id_campo = 4
			left join campo_pessoa TCA on TCA.cd_pes = PR.cd_pes and TCA.id_campo = 5
			left join campo_pessoa TCC on TCC.cd_pes = PR.cd_pes and TCC.id_campo = 7
			left join sispag S on S.lote = PR.sispag
			left join sispag_tipo_pagamento STP on Stp.cd_tipo = S.tipopagamento
			left join sispag_forma_pagamento SFP on SFp.cd_forma = S.formapagamento
		where sispag = @lote
	END


	
GO
