SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pJob_Sel
(
@JOB		VarChar(16)=''
)
AS
	If @JOB = '' 
		Begin 
			Select Job_HIM as Job from house_imp_mar where Job_HIM like 'IMJOB%'
			Union
			Select Job_HIA as Job from house_imp_Aer where Job_HIA like 'IAJOB%'
			Union
			Select Job_HEA as Job from house_exp_Aer where Job_HEA like 'IEJOB%'
			Union
			Select Job_HEM as Job from house_Exp_Mar where Job_HEM like 'EMJOB%'
		End 
	Else
		Begin 
			If Left(@JOB, 2) = 'IA'
				Select Job_HIA as Job, Apelido as Pessoa, Cd_Pes  from House_imp_Aer as HIA Join Pessoa on Pessoa.Cd_Pes = HIA.Cd_Import_HIA Where Job_HIA = @JOB

			If Left(@JOB, 2) = 'IM'
				Select Job_HIM as Job, Apelido as Pessoa, Cd_Pes  from House_imp_mar as HIM Join Pessoa on Pessoa.Cd_Pes = HIM.Cd_Import_HIM where Job_HIM = @JOB 

			If Left(@JOB, 2) = 'EA'
				Select Job_HEA as Job, Apelido as Pessoa, Cd_Pes  from House_exp_Aer as HEA Join Pessoa on Pessoa.Cd_Pes = HEA.Cd_Export_HEA where Job_HEA = @JOB

			If Left(@JOB, 2) = 'EM'
				Select Job_HEM as Job, Apelido as Pessoa, Cd_Pes  from House_Exp_Mar as HEM Join Pessoa on Pessoa.Cd_Pes = HEM.Cd_Export_HEM where Job_HEM = @JOB

		End
GO
