SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spRegistroFinanceiro_Sel] --'04','2012','000005'
	
@Mes		varchar(2),
@Ano		varchar(4),
@Registro	varchar(6)
	
	as
		select
			RF.ID ID, RF.Num_Registro Registro,RF.Mes Mes, RF.Ano Ano,P.Apelido Companhia, Num_CNPJ,TRF.cd_Tipo_Lanc + ' - ' + TRF.Descricao_Tp_lancamento Lancamento, RF.Dt_Ins, Dt_Venc, Isento,
			Nome_Tp_Moeda Moeda, RF.Par_Moeda Valor, Cd_Regra, cd_Tp_fatura, cd_tipo_Doc_rf +' - '+ descricao_Tp_Doc Tipo_Doc,isnull(Doc_Number,'') Doc_Number,
			sg.Apelido Apelido_Seguro,num_cnpj_seguro, RF.Ativo,isnull(Habilita_Impostos,0) Habilita_Impostos,
			isnull(Ref_Acesso,'N') Ref_Acesso,
			(convert(varchar(50),S.cd_servico) + ' - ' + S.Item_lei + ' - ' + S.Descricao) Servico
		from 
			Registro_Financeiro RF
			left join pessoa P					on P.Cd_pes = RF.cd_pes
			left join Tipo_lancamento_RF TRF	on TRF.Cd_Tipo_Lanc = RF.Cd_Tipo_Lanc
			left join Tipo_moeda TM				on TM.CD_Tp_Moeda = RF.Cd_Tp_moeda
			left join Tipo_Doc_RF DRF			on DRF.Cd_Tipo_Doc_RF = Rf.Cd_Tp_doc
			Left Join Pessoa SG					on SG.cd_pes=Cd_pes_seguro
			left join Tipo_NF_Doc_Register S	on S.cd_servico = RF.cd_servico and S.Item_lei = RF.Item_lei
		where
			Mes = @Mes and Ano = @Ano and Num_Registro= @Registro




GO
