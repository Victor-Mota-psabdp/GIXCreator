SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE	PROCEDURE spContainerEM_Rel --'EMSSZ20040901401'
(
@Processo	Varchar(16)
)
as
	select
		count(HOU.item_cont_em) qtd, TP.nome_tp_cont
	from
		container_hou_exp_mar  HOU
		Join container_mas_exp_mar MAS on MAS.item_cont_em = HOU.item_cont_em and MAS.num_proc_MEM = HOU.num_proc_MEM
		join tipo_container TP on TP.cd_tp_cont = MAS.cd_tp_cont
	Where
		HOU.num_proc_hem=@Processo
	group by
		TP.nome_tp_cont


GO
