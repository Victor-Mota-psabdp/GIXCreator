SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




create   PROCEDURE spRelacao_sel
		
		@cd_pes varchar(10)

as


SELECT
	Apelido,Nome_tp_rel,Obs_Rel
FROM
	Relacao RL
	JOIN Tipo_Relacao TR on TR.cd_tp_rel=RL.cd_tp_rel
	Join Pessoa on cd_pes=cd_pes_b
WHERE
	cd_pes_a=@cd_pes





GO
