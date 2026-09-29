SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE function house(
			@Proc varchar (16) 
			
		)returns varchar (30)
AS 

BEGIN
	return (
		SELECT CASE left(@Proc,2)
			WHEN 'IA' THEN	 (select hawb_hia from house_imp_aer where num_proc_hia=@proc)
			WHEN 'EA' THEN	 (select hawb_hea from house_exp_aer where num_proc_hea=@proc)
			WHEN 'IM' THEN   (select hawb_him from house_imp_mar where num_proc_him=@proc)
			WHEN 'EM' THEN   (select hawb_hEM from house_EXP_mar where num_proc_hEm=@proc)
		END
		)
END




GO
