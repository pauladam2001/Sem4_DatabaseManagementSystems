using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Configuration;

namespace Homework1
{
    public partial class Form1 : Form
    {

        SqlConnection dbConn;
        SqlDataAdapter daParent, daChild;
        DataSet ds;
        BindingSource bsParent, bsChild;
        SqlCommandBuilder cbChild;            // we need it for SqlDataAdapter Update command

        private void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                daChild.Update(ds, getChildTable());
                MessageBox.Show("Changes were saved successfully!");
            }
            catch (Exception exception)
            {
                MessageBox.Show(exception.Message);
            }
        }

        public Form1()
        {
            InitializeComponent();
        }

        private string getConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["connString"].ConnectionString.ToString();
        }

        private string getPKName()
        {
            return ConfigurationManager.AppSettings["parentTablePK"];
        }

        private string getFKName()
        {
            return ConfigurationManager.AppSettings["childTableFK"];
        }

        private string getParentTable()
        {
            return ConfigurationManager.AppSettings["parentTable"];
        }

        private string getChildTable()
        {
            return ConfigurationManager.AppSettings["childTable"];
        }

        private string getParentQuery()
        {
            return ConfigurationManager.AppSettings["parentTableQuery"];
        }

        private string getChildQuery()
        {
            return ConfigurationManager.AppSettings["childTableQuery"];
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            dbConn = new SqlConnection(getConnectionString());
           
            ds = new DataSet();

            daParent = new SqlDataAdapter(getParentQuery(), dbConn);
            daChild = new SqlDataAdapter(getChildQuery(), dbConn);

            cbChild = new SqlCommandBuilder(daChild);

            daParent.Fill(ds, getParentTable());
            daChild.Fill(ds, getChildTable());

            DataRelation dr = new DataRelation("FK_Child_Parent", ds.Tables[getParentTable()].Columns[getPKName()], ds.Tables[getChildTable()].Columns[getFKName()]);

            ds.Relations.Add(dr);

            bsParent = new BindingSource();
            bsParent.DataSource = ds;
            bsParent.DataMember = getParentTable();

            bsChild = new BindingSource();
            bsChild.DataSource = bsParent;
            bsChild.DataMember = "FK_Child_Parent";

            dgvParent.DataSource = bsParent;
            dgvChild.DataSource = bsChild;
        }
    }
}
